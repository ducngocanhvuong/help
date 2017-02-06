

    Fix lỗi UNUSABLE inddex or partition
        Tìm index lỗi: SELECT owner, index_name, tablespace_name FROM dba_indexes WHERE status = 'UNUSABLE';
        Tìm partition lỗi SELECT index_owner, index_name, partition_name, tablespace_name FROM dba_ind_PARTITIONS WHERE status = 'UNUSABLE';

    Fix lỗi: Indexes:

    SELECT 'alter index '||index_name||' rebuild tablespace '||tablespace_name ||';' FROM dba_indexes WHERE status = 'UNUSABLE';

    Index partitions:

    SELECT 'alter index '||index_name ||' rebuild partition '||PARTITION_NAME||' TABLESPACE '||tablespace_name ||';' FROM dba_ind_partitions WHERE status = 'UNUSABLE';

    ALTER INDEX tên_index REBUILD;

