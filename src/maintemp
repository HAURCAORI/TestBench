#include <iostream>
#include "H5Cpp.h"

using namespace H5;

const H5std_string FILE_NAME("SDS.h5");
const H5std_string DATASET_NAME("IntArray");
//const int NX = 5; // dataset dimensions
//const int NY = 6;
const int RANK = 3;

const int NX_SUB = 3; // hyperslab dimensions
const int NY_SUB = 4;
const int NX = 7; // output buffer dimensions
const int NY = 7;
const int NZ = 3;
const int RANK_OUT = 3;

int createHDF5()
{
    /*
    * Data initialization.
    */
    int i, j;
    int data[NX][NY][NZ]; // buffer for data to write
    for (j = 0; j < NX; j++)
    {
        for (i = 0; i < NY; i++)
        {
            for (int k = 0; k < NZ; k++)
                data[j][i][k] = i + j+ k;
        }
    }
    /*
    * 0 1 2 3 4 5
    * 1 2 3 4 5 6
    * 2 3 4 5 6 7
    * 3 4 5 6 7 8
    * 4 5 6 7 8 9
    */
    // Try block to detect exceptions raised by any of the calls inside it
    try
    {
        /*
       * Turn off the auto-printing when failure occurs so that we can
       * handle the errors appropriately
       */
        Exception::dontPrint();
        /*
       * Create a new file using H5F_ACC_TRUNC access,
       * default file creation properties, and default file
       * access properties.
       */
        H5File file(FILE_NAME, H5F_ACC_TRUNC);
        /*
       * Define the size of the array and create the data space for fixed
       * size dataset.
       */
        hsize_t dimsf[3]; // dataset dimensions
        dimsf[0] = NX;
        dimsf[1] = NY;
        dimsf[2] = NZ;
        DataSpace dataspace(RANK, dimsf);
        /*
       * Define datatype for the data in the file.
       * We will store little endian INT numbers.
       */
        IntType datatype(PredType::NATIVE_INT);
        datatype.setOrder(H5T_ORDER_LE);
        /*
       * Create a new dataset within the file using defined dataspace and
       * datatype and default dataset creation properties.
       */
        DataSet dataset = file.createDataSet(DATASET_NAME, datatype, dataspace);
        /*
       * Write the data to the dataset using default memory space, file
       * space, and transfer properties.
       */
        dataset.write(data, PredType::NATIVE_INT);
    } // end of try block
    // catch failure caused by the H5File operations
    catch (FileIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSet operations
    catch (DataSetIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSpace operations
    catch (DataSpaceIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSpace operations
    catch (DataTypeIException error)
    {
        error.printErrorStack();
        return -1;
    }
    return 0;
}

int readHDF5()
{
    /*
    * Output buffer initialization.
    */
    int i, j, k;
    int data_out[NX][NY][NZ]; /* output buffer */
    for (j = 0; j < NX; j++)
    {
        for (i = 0; i < NY; i++)
        {
            for (k = 0; k < NZ; k++)
                data_out[j][i][k] = 0;
        }
    }
    /*
    * Try block to detect exceptions raised by any of the calls inside it
    */
    try
    {
        /*
       * Turn off the auto-printing when failure occurs so that we can
       * handle the errors appropriately
       */
        Exception::dontPrint();
        /*
       * Open the specified file and the specified dataset in the file.
       */
        H5File file(FILE_NAME, H5F_ACC_RDONLY);
        DataSet dataset = file.openDataSet(DATASET_NAME);
        /*
       * Get the class of the datatype that is used by the dataset.
       */
        H5T_class_t type_class = dataset.getTypeClass();
        /*
       * Get class of datatype and print message if it's an integer.
       */
        if (type_class == H5T_INTEGER)
        {
            std::cout << "Data set has INTEGER type" << std::endl;
            /*
      * Get the integer datatype
          */
            IntType intype = dataset.getIntType();
            /*
          * Get order of datatype and print message if it's a little endian.
          */
            H5std_string order_string;
            H5T_order_t order = intype.getOrder(order_string);
            std::cout << order_string << std::endl;
            /*
          * Get size of the data element stored in file and print it.
          */
            size_t size = intype.getSize();
            std::cout << "Data size is " << size << std::endl;
        }
        /*
       * Get dataspace of the dataset.
       */
        DataSpace dataspace = dataset.getSpace();
        /*
       * Get the number of dimensions in the dataspace.
       */
        int rank = dataspace.getSimpleExtentNdims();
        /*
       * Get the dimension size of each dimension in the dataspace and
       * display them.
       */
        hsize_t dims_out[3];
        int ndims = dataspace.getSimpleExtentDims(dims_out, NULL);
        std::cout << "rank " << rank << ", dimensions " << (unsigned long)(dims_out[0]) << " x " << (unsigned long)(dims_out[1]) << " x " << (unsigned long)(dims_out[2]) << std::endl;
        /*
       * Define hyperslab in the dataset; implicitly giving strike and
       * block NULL.
       */
        hsize_t offset[3]; // hyperslab offset in the file
        hsize_t count[3];  // size of the hyperslab in the file
        offset[0] = 1;
        offset[1] = 2;
        offset[2] = 0;
        count[0] = NX_SUB;
        count[1] = NY_SUB;
        count[2] = 3;
        dataspace.selectHyperslab(H5S_SELECT_SET, count, offset);
        /*
       * Define the memory dataspace.
       */
        hsize_t dimsm[3]; /* memory space dimensions */
        dimsm[0] = NX;
        dimsm[1] = NY;
        dimsm[2] = NZ;
        DataSpace memspace(RANK_OUT, dimsm);
        /*
       * Define memory hyperslab.
       */
        hsize_t offset_out[3]; // hyperslab offset in memory
        hsize_t count_out[3];  // size of the hyperslab in memory
        
        offset_out[0] = 3;
        offset_out[1] = 0;
        offset_out[2] = 0;
        count_out[0] = NX_SUB;
        count_out[1] = NY_SUB;
        count_out[2] = 3;
        memspace.selectHyperslab(H5S_SELECT_SET, count_out, offset_out);
        /*
       * Read data from hyperslab in the file into the hyperslab in
       * memory and display the data.
       */
        dataset.read(data_out, PredType::NATIVE_INT, memspace, dataspace);
        for(int k = 0; k < NZ; k++) {
            for (j = 0; j < NX; j++)
            {
                for (i = 0; i < NY; i++)
                    std::cout << data_out[j][i][k] << " ";
                std::cout << std::endl;
            }
            std::cout << "- - - - - - -" << std::endl;
        }
        /*
       * 0 0 0 0 0 0 0
       * 0 0 0 0 0 0 0
       * 0 0 0 0 0 0 0
       * 3 4 5 6 0 0 0
       * 4 5 6 7 0 0 0
       * 5 6 7 8 0 0 0
       * 0 0 0 0 0 0 0
       */
    } // end of try block
    // catch failure caused by the H5File operations
    catch (FileIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSet operations
    catch (DataSetIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSpace operations
    catch (DataSpaceIException error)
    {
        error.printErrorStack();
        return -1;
    }
    // catch failure caused by the DataSpace operations
    catch (DataTypeIException error)
    {
        error.printErrorStack();
        return -1;
    }
    return 0; // successfully terminated
}

int main(void)
{
    createHDF5();
    readHDF5();
    return 0; // successfully terminated
}
