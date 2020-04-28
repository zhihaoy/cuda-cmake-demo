#include <cuda-cmake-demo/daxpy.h>

#include <thrust/device_vector.h>
#include <thrust/transform.h>

namespace cuda_cmake_demo
{

void daxpy(size_t n, double a, double const* x, double* y)
{
    using namespace thrust::placeholders;
    thrust::device_vector<double> d_x(x, x + n), d_y(y, y + n);

    thrust::transform(d_x.begin(), d_x.end(), d_y.begin(), d_y.begin(),
                      a * _1 + _2);
    thrust::copy(d_y.begin(), d_y.end(), y);
}

}
