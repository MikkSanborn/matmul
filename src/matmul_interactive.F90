
#ifndef BUILD_TYPE
#define BUILD_TYPE ('unspecified')
#endif // BUILD_TYPE

program main
   use, intrinsic :: iso_fortran_env, only: INT64
   implicit none

   integer :: N

   real, allocatable :: A(:,:), B(:,:), C(:,:)
   integer(kind=INT64) :: c_start, c_stop, c_rate
   integer :: i, j

   read(*, *) N

   allocate(A(N, N))
   allocate(B(N, N))
   allocate(C(N, N))

   call random_number(A)
   call random_number(B)

   !A = 1
   !B = 1
   !C = 0

   call system_clock(c_start, c_rate)
   do concurrent (i=1:N, j=1:N)
      C(i,j) = sum(A(i,:)**2 * B(:,j))
   end do
   call system_clock(c_stop)

   associate ( &
        time => real(c_stop-c_start)/c_rate, &
        flops => 3*real(N)**3 &
        )

        !print*, BUILD_TYPE, time, flops, flops/time, sum(C), sum(A), sum(B), N
        write(*, '(A12, A3, 4X, F8.3, 4X, 2(E12.7, 4x), E12.7, 4x, I8)') &
            & "interactive_", BUILD_TYPE, time, flops, flops/time, sum(C), N

   end associate

   deallocate(A)
   deallocate(B)
   deallocate(C)

end program main

