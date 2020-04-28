#include <cuda-cmake-demo/daxpy.h>

#include <iostream>
#include <numeric>
#include <vector>

int main()
{
    std::vector<double> x(100000), y(100000);
    std::iota(begin(x), end(x), 1.);
    std::iota(begin(y), end(y), 2.);
    cuda_cmake_demo::daxpy(size(x), 0.5, x.data(), y.data());

    for (size_t i = size(x) - 10; i != size(x); ++i)
    {
        std::cout << x[i] << '\t' << y[i] << '\n';
    }
}
