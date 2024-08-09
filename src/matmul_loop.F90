
#ifndef BUILD_TYPE
#define BUILD_TYPE ('unspecified')
#endif // BUILD_TYPE

program main
   use, intrinsic :: iso_fortran_env, only: INT64
   implicit none

#ifndef N_VALUES
   integer, parameter :: N = 2048
#else // ifdef N_VALUES
   integer, parameter :: N = N_VALUES
#endif // N_VALUES

   real, dimension(N,N) :: A, B, C
   integer(kind=INT64) :: c_start, c_stop, c_rate
   integer :: i, j, k

   call random_number(A)
   call random_number(B)

   !A = 1
   !B = 1
   !C = 0

   do k = 1, 2

      call system_clock(c_start, c_rate)
      do concurrent (i=1:N, j=1:N)
         C(i,j) = sum(A(i,:) * B(:,j))
      end do
      call system_clock(c_stop)

      associate ( &
           time => real(c_stop-c_start)/c_rate, &
           flops => 3*real(N)**2 &
           )

           !print*, BUILD_TYPE, time, flops, flops/time, sum(C), sum(A), sum(B), N
         write(*, '(A6, A3, 4X, F8.3, 4X, 2(E12.7, 4x), E12.7, 4x, I8)') &
             & "matmL_", BUILD_TYPE, time, flops, flops/time, sum(C), N

      end associate

   end do

end program main

