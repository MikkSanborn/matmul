
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
   integer, parameter :: BLOCK_SIZE = 128 ! 8

   real, dimension(N,N) :: A, B, C
   integer(kind=INT64) :: c_start, c_stop, c_rate
   integer :: i, j, ii, jj, kk
   integer :: i0, i1, j0, j1, k0, k1

   call random_number(A)
   call random_number(B)

   !A = 1
   !B = 1
   !C = 0

   call system_clock(c_start, c_rate)
   do concurrent(k0=1:N:BLOCK_SIZE)
      k1 = min(N, k0 + BLOCK_SIZE - 1)

      do concurrent (j0=1:N:BLOCK_SIZE,i0=1:N:BLOCK_SIZE)
         j1 = min(N, j0 + BLOCK_SIZE - 1)
         i1 = min(N, i0 + BLOCK_SIZE - 1)

         do concurrent(j=j0:j1,i=i0:i1)
            c(i,j) = c(i,j) + sum(a(i,k0:k1)*b(k0:k1,j))
         end do

      end do
   end do

   call system_clock(c_stop)
   associate ( &
        time => real(c_stop-c_start)/c_rate, &
        flops => 2*real(N)**3 &
        )

      !print*, time, flops, flops/time, sum(c)
      write(*, '(A6, A3, 4X, F8.3, 4X, 2(E12.7, 4x), E12.7, 4x, I8)') &
            & "block_", BUILD_TYPE, time, flops, flops/time, sum(C), N
   end associate

end program main

