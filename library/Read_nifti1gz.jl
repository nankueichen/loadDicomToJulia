module Read_nifti1gz
 
    export load_niigz_header
    export load_niigz_data

    import GZip

    function load_niigz_header(filename::String)    
        headerinfo = Dict()
        fid = GZip.open(filename,"r")
        testvalue = read(fid,Int32,1);
        headerinfo["sizeof_hdr"] = testvalue
        testvalue = read(fid,Int8,10);
        headerinfo["data_type"] = testvalue
        testvalue = read(fid,Int8,18);
        headerinfo["db_name"] = testvalue
        testvalue = read(fid,Int32,1);
        headerinfo["extents"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["session_error"] = testvalue
        testvalue = read(fid,Int8,1);
        headerinfo["regular"] = testvalue
        testvalue = read(fid,Int8,1);
        headerinfo["dim_info"] = testvalue
        testvalue = read(fid,Int16,8);
        headerinfo["dim"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["intent_p1"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["intent_p2"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["intent_p3"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["intent_code"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["datatype"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["bitpix"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["slice_start"] = testvalue
        testvalue = read(fid,Float32,8);
        headerinfo["pixdim"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["vox_offset"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["scl_slope"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["scl_inter"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["slice_end"] = testvalue
        testvalue = read(fid,Int8,1);
        headerinfo["slice_code"] = testvalue
        testvalue = read(fid,Int8,1);
        headerinfo["xyzt_units"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["cal_max"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["cal_min"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["slice_duration"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["toffset"] = testvalue
        testvalue = read(fid,Int32,1);
        headerinfo["glmax"] = testvalue
        testvalue = read(fid,Int32,1);
        headerinfo["glmin"] = testvalue
        testvalue = read(fid,Int8,80);
        headerinfo["descrip"] = testvalue
        testvalue = read(fid,Int8,24);
        headerinfo["aux_file"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["qform_code"] = testvalue
        testvalue = read(fid,Int16,1);
        headerinfo["sform_code"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["quatern_b"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["quatern_c"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["quatern_d"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["qoffset_x"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["qoffset_y"] = testvalue
        testvalue = read(fid,Float32,1);
        headerinfo["qoffset_z"] = testvalue
        testvalue = read(fid,Float32,4);
        headerinfo["srow_x"] = testvalue
        testvalue = read(fid,Float32,4);
        headerinfo["srow_y"] = testvalue
        testvalue = read(fid,Float32,4);
        headerinfo["srow_z"] = testvalue
        testvalue = read(fid,Int8,16);
        headerinfo["intent_name"] = testvalue
        testvalue = read(fid,Int8,4);
        headerinfo["magic"] = testvalue
        close(fid)
        headerinfo["qfac"] = headerinfo["pixdim"][1];
        headerinfo["filename"]= filename;
        return headerinfo;
    end

    function load_niigz_data(filename::String, headerinfo)
        zdim::Int = headerinfo["dim"][4];
        ydim::Int = headerinfo["dim"][3];
        xdim::Int = headerinfo["dim"][2];
        tdim::Int = headerinfo["dim"][5];
        ndim::Int = headerinfo["dim"][1];
        offset::Int = convert(Int,headerinfo["vox_offset"][1]);
        fid = GZip.open(filename,"r")
        seek(fid,offset)
        if headerinfo["datatype"][1]  == 2 
            data = read(fid,UInt8,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 4
            data = read(fid,Int16,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 8 
            data = read(fid,Int32,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 16 
            data = read(fid,Float32,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 64 
            data = read(fid,Float64,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 256 
            data = read(fid,Int8,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 512 
            data = read(fid,UInt16,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 768 
            data = read(fid,UInt32,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 1024 
            data = read(fid,Int64,xdim*ydim*zdim*tdim)
        elseif headerinfo["datatype"][1]  == 1280 
            data = read(fid,UInt64,xdim*ydim*zdim*tdim)
        else
            data = [];
            println("-- nii data were not loaded properly --")
        end
        close(fid);
        if ndim == 4
            data = reshape(data,xdim,ydim,zdim,tdim);
        elseif ndim == 3
            data = reshape(data,xdim,ydim,zdim);
        end
        return data;
    end
    # datatype:
    #define NIFTI_TYPE_UINT8           2 /! unsigned char. /
    #define NIFTI_TYPE_INT16           4 /! signed short. /
    #define NIFTI_TYPE_INT32           8 /! signed int. /
    #define NIFTI_TYPE_FLOAT32        16 /! 32 bit float. /
    #define NIFTI_TYPE_COMPLEX64      32 /! 64 bit complex = 2 32 bit floats. /
    #define NIFTI_TYPE_FLOAT64        64 /! 64 bit float = double. /
    #define NIFTI_TYPE_RGB24         128 /! 3 8 bit bytes. /
    #define NIFTI_TYPE_INT8          256 /! signed char. /
    #define NIFTI_TYPE_UINT16        512 /! unsigned short. /
    #define NIFTI_TYPE_UINT32        768 /! unsigned int. /
    #define NIFTI_TYPE_INT64        1024 /! signed long long. /
    #define NIFTI_TYPE_UINT64       1280 /! unsigned long long. /
    #define NIFTI_TYPE_FLOAT128     1536 /! 128 bit float = long double. /
    #define NIFTI_TYPE_COMPLEX128   1792 /! 128 bit complex = 2 64 bit floats. /
    #define NIFTI_TYPE_COMPLEX256   2048 /! 256 bit complex = 2 128 bit floats /


end




