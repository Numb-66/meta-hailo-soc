#!/bin/bash

declare -r SCRIPT=$(basename "$0")
declare -i PID=$$
declare -r LOCK_FILE="/tmp/$SCRIPT.lock"

declare separator_4=$(printf '%*s' "4" '' | tr ' ' '-')
declare separator_8=$(printf '%*s' "8" '' | tr ' ' '-')
declare separator_16=$(printf '%*s' "16" '' | tr ' ' '-')
declare separator_20=$(printf '%*s' "20" '' | tr ' ' '-')
declare separator_25=$(printf '%*s' "25" '' | tr ' ' '-')
declare separator_37=$(printf '%*s' "37" '' | tr ' ' '-')

# DMA Heaps & exporters information
declare -a exporter_names=($(find /sys/kernel/dmabuf/buffers/ -name "exporter_name" -exec cat {} \; 2>/dev/null | sort -u))
declare -i num_of_exporters=${#exporter_names[@]}
declare -A exporter_sizes
declare -i total_exporter_sizes=0
declare -i total_heaps_sizes=0

declare cma_meminfo="$(grep -i cma /proc/meminfo)"
declare -i cma_total=$(echo "$cma_meminfo" | grep -i total | awk '{print $2*1024}')
declare -i cma_free=$(echo "$cma_meminfo" | grep -i free | awk '{print $2*1024}')
declare -i cma_used=$((cma_total - cma_free))

declare buf_info=""

# Command line options variables.
declare -i F_SHOW_VERBOSE=0
declare F_UNIT_FORMAT="A" # B(Bytes)/K(KiB)/M(MiB)/G(GiB)/A(Auto)

trap 'trap_func' TERM INT
trap_func()
{
    echo "$SCRIPT interrupted. Exiting."
    rm -rf "$LOCK_FILE"
}

# @brief script usage.
function usage()
{
  echo "Usage: $SCRIPT [OPTIONS]"
  echo "       -h|--help: show help."
  echo "       -v|--verbose: show also overall DMA_BUF usage per exporter"
  echo "       -u|--unit B/K/M/G/A: show size format in Bytes/KiB/MiB/GiB units, default to A(auto) format"
  return 0
}

function format_number()
{
    local num="$1"
    local str_out=""
    
    case "$F_UNIT_FORMAT" in
    "A") str_out=$(numfmt --to=iec-i --format="%.3f" "$num") ;;
    "B") str_out=$(numfmt --format="%f" "$num") ;;
    "K") str_out=$(numfmt --to-unit=$((1<<10)) --format="%.3fKiB" "$num") ;;
    "M") str_out=$(numfmt --to-unit=$((1<<20)) --format="%.3fMiB" "$num") ;;
    "G") str_out=$(numfmt --to-unit=$((1<<30)) --format="%.3fGiB" "$num") ;;
    *) ;;
    esac

    echo "$str_out"
    return 0
}

# @brief Prepare DMA_BUF heaps & exporters info.
function dma_heap_info_prepare()
{
    # Init Mapping [exporter-name -> int] entries
    for ((i=0; i<num_of_exporters; i++)); do
        exporter_sizes[${exporter_names[$i]}]=0
    done

    # Sample DMA buf info
    buf_info="$(grep -v 'exp_name\|bytes' /sys/kernel/debug/dma_buf/bufinfo | awk 'NF == 6')"

    # Calculate overall usage per DMA_BUF exporter
    for key in "${!exporter_sizes[@]}"; do
        exporter_sizes[$key]=$(echo "$buf_info" | grep "$key" | awk '{sum+=$1} END {printf("%d\n", sum)}')
        total_exporter_sizes=$((total_exporter_sizes + exporter_sizes[$key]))
    done
    
    return 0
}

# @brief show CMA info.
function cma_info()
{
    local hdr_separator=$(printf "%-20s  %-16s\n" "$separator_20" "$separator_16")
    local hdr_info=$(printf "%-20s  %-16s" "CMA" "Size")

    [ -z "$cma_total" ] && return 0

    echo "$hdr_separator"
    echo "$hdr_info"
    echo "$hdr_separator"
    printf "%-20s  %-16s\n" "Used" "$(format_number "$cma_used")"
    printf "%-20s  %-16s\n" "Free" "$(format_number "$cma_free")"
    echo "$hdr_separator"
    printf "%-20s  %-16s\n\n\n" "Total" "$(format_number "$cma_total")"

    return 0
}

# @brief List DMA_BUF heaps info & usage.
function dma_heap_info()
{
	local reseved_mem_path="/sys/firmware/devicetree/base/reserved-memory"
    local hdr_separator=$(printf "%-20s  %-16s  %-16s  %4s  %-16s  %-37s\n" "$separator_20" "$separator_16" "$separator_16" "$separator_4" "$separator_16" "$separator_37")
    local hdr_info=$(printf "%-20s  %-16s  %-16s  %4s  %-16s  %-37s\n" "Heap-Name" "Size" "Used" "Use%" "Free" "Physical-Allocation-Range")
    local -i used_hailo_media_buf_cma=$(echo "$buf_info" | grep 'hailo_media_buf,cma' | awk '{sum+=$1} END {printf("%d", sum)}')
    local -i total_used=0
    local -i total_free=0

    [ ! -e /dev/dma_heap/ ] && echo "No heaps found" && return 0

    echo "$hdr_separator"
    echo "$hdr_info"
    echo "$hdr_separator"
    for heap in $(ls /dev/dma_heap/); do
        heap_size=$(( $(hexdump -v -e '"0x" 8/1 "%02x"' -e '"\n"' "${reseved_mem_path}/$heap/size") ))
        heap_alloc_ranges=($(hexdump -v -e '"0x" 8/1 "%02x"' -e '"\n"' "${reseved_mem_path}/$heap/alloc-ranges"))
        range_base=$((${heap_alloc_ranges[0]}))
        range_end=$((${heap_alloc_ranges[0]} + ${heap_alloc_ranges[1]} - 1))
        
        if [ "$heap" == "hailo_media_buf,cma" ]; then
            used_dma_buf=$used_hailo_media_buf_cma
        else
            used_dma_buf=$((cma_used - used_hailo_media_buf_cma))
        fi
        
        total_heaps_sizes=$((total_heaps_sizes + heap_size))
        total_used=$((total_used + used_dma_buf))
        total_free=$((total_free + (heap_size - used_dma_buf)))

        printf "%-20s  %-16s  %-16s  %4s  %-16s  [%016x - %016x]\n" \
            "$heap" \
            "$(format_number "$heap_size")" \
            "$(format_number "$used_dma_buf")" \
            "$((used_dma_buf * 100 / heap_size))" \
            "$(format_number $((heap_size - used_dma_buf)))" \
            "$range_base" "$range_end"
    done
    echo "$hdr_separator"
    printf "%-20s  %-16s  %-16s  %4s  %-16s\n\n\n" \
        "Total" \
        "$(format_number "$total_heaps_sizes")" \
        "$(format_number "$total_used")" \
        "$((total_used * 100 / total_heaps_sizes))" \
        "$(format_number "$total_free")"

    return 0
}

# @brief List overall DMA_BUF usage per exporter.
function dmabuf_per_exporter_info()
{
    [ "$total_exporter_sizes" -eq 0 ] && return 0

    local hdr_separator=$(printf "%-25s  %-16s\n" "$separator_25" "$separator_16")
    local hdr_info=$(printf "%-25s  %-16s\n" "Exporter-Name" "Used")

    echo "$hdr_separator"
    echo "$hdr_info"
    echo "$hdr_separator"
    for key in "${!exporter_sizes[@]}"; do
        printf "%-25s  %-16s\n" "$key" "$(format_number "${exporter_sizes[$key]}")"
    done
    echo "$hdr_separator"
    printf "%-25s  %-16s\n\n\n" "Total" "$(format_number "$total_exporter_sizes")"
    
    return 0
}

# @brief main.
main()
{
    case "$F_UNIT_FORMAT" in
    "A"|"B"|"K"|"M"|"G") ;;
    *) usage && return 0 ;;
    esac
    
    cma_info
    dma_heap_info_prepare
    dma_heap_info
    [ "$F_SHOW_VERBOSE" -eq 1 ] && dmabuf_per_exporter_info

    return 0
}

#------------------------------------------------------------------------------
#                               MAIN
#------------------------------------------------------------------------------
(
    flock -xn 200 || { echo "$SCRIPT is already running."; exit 1; }

    OPTS_SHORT="hvu:"   # Legal short options
    OPTS_LONG="help,verbose,unit:" # Legal long options
    # $PARSED_OPTIONS will contain the legal arguments out of "$@".
    PARSED_OPTIONS=$(getopt -n "$0" -o $OPTS_SHORT -l $OPTS_LONG -- "$@") || {
        rm -rf "$LOCK_FILE"
        exit 1
    }

    eval set -- "$PARSED_OPTIONS"     # Set the positional parameters ($1, $2, etc)

    while true; do
        case "$1" in
        --help|-h) usage && exit 0 ;;
        --verbose|-v)  F_SHOW_VERBOSE=1; shift 1 ;;
        --unit|-u)  F_UNIT_FORMAT="$2"; shift 2 ;;
        --) shift; break ;;
        *) echo "Argument [$1] not handled."; shift; break ;;
        esac
    done

    main "$@"
    rm -rf "$LOCK_FILE"
    exit $?
) 200>"$LOCK_FILE"

