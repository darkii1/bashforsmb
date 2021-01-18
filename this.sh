BASE_DIR="/mnt"

TEST_FILENAME_PREFIX="fiotestfile"
TEST_FILE_SIZE="1G"
TIMEOUT=120

BASE_RESULT_DIR="iotest-res"
RESULT_FILENAME="result.json"

DIRS_FOR_TEST=(nfs-async smb gfs nfs-sync)

IO_TEST_TYPES=(read write randread randwrite)

BLOCK_SIZES=(4 16 64 128)

echo "Start tests..."
for test_type in ${IO_TEST_TYPES[*]}
do
  for block_size in ${BLOCK_SIZES[*]}
  do
    for fsdir in ${DIRS_FOR_TEST[*]}
    do
      echo "Test: fs=$fsdir; type=$test_type; block size=$block_size. Start at $(date)"

      RESULT_DIR="$BASE_RESULT_DIR/$fsdir/$test_type/$block_size"
      mkdir -p "$RESULT_DIR"

      TEST_NAME="$fsdir-$test_type-$block_size"
      TEST_FILENAME="$BASE_DIR/$fsdir/$TEST_FILENAME_PREFIX-$TEST_NAME"

      fio --name="$TEST_NAME" --filename="$TEST_FILENAME" --direct=1 --rw="$test_type"  --bs=${block_size}kb --size=$TEST_FILE_SIZE --runtime=$TIMEOUT --output-format=json > "$RESULT_DIR/$RESULT_FILENAME"

      rm "$TEST_FILENAME"
    done
  done
done
echo "Tests finished!"
