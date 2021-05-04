reset

#=================== Parameter ====================
Nx = 200		# Number of cells (width)
Ny = 100		# Number of cells (height)
N = Nx*Ny		# Number of cells

#=================== Setting ====================
set terminal png enhanced font "Times" 20 size 1280, 720
unset key
unset border
set xr[0:Nx]
set yr[0:Ny]
unset xtics
unset ytics
set size ratio -1
unset grid

array a[N]										# Old generation
array b[N]										# New generation
title(i) = sprintf("Generations: %5d\n", i)		# Counter

#=================== Draw initiate state using random ====================
do for [i=1:Ny] {
	do for [j=1:Nx] {
		m = Nx*(i-1)+j
		a[m] = ceil(rand(0)-0.5)

		if(a[m]==0){
			set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "white"
		} else {
			set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "black"
		}
	}
}

# Draw number of generations
set label 1 center title(1) font 'Times New Roman, 24' at graph 0.50, 1.03
filename = sprintf("png/img_%04d.png",1)
set output filename
plot 1/0

#=================== Plot ====================
do for [k=1:1000-1] {
	do for [i=1:Ny] {
		do for [j=1:Nx] {
			l = Nx*(i-2)+j		# Lower column
			m = Nx*(i-1)+j		# Column focused on
			n = Nx*i+j			# Upper column

			# Count statuses of cell(a[m])'s neighbors
			if(i==1){
				if(j==1){
					sum = a[2]+a[Nx+1]+a[Nx+2] # Region A
				} else {if(j==Nx){
					sum = a[Nx-1]+a[2*Nx-1]+a[2*Nx] # Region B
				} else {
					sum = a[m-1]+a[m+1]+a[n-1]+a[n]+a[n+1] # Region C
				}}
			}
			if(i==Ny){
				if(j==1){
					sum = a[Nx*(Ny-2)+1]+a[Nx*(Ny-2)+2]+a[Nx*(Ny-1)+2] # Region D
				} else {if(j==Nx){
					sum = a[Nx*(Ny-1)-1]+a[Nx*(Ny-1)]+a[Nx*Ny-1] # Region E
				} else {
					sum = a[l-1]+a[l]+a[l+1]+a[m-1]+a[m+1] # Region F
				}}
			}
			if(j==1 && (i!=1 && i!=Ny)){
				sum = a[l]+a[l+1]+a[m+1]+a[n]+a[n+1] # Region G
			}
			if(j==Nx && (i!=1 && i!=Ny)){
				sum = a[l-1]+a[l]+a[m-1]+a[n-1]+a[n] # Region H
			}
			if((j>1 && j<Nx) && (i>1 && i<Ny)) {
				sum = a[l-1]+a[l]+a[l+1]+a[m-1]+a[m+1]+a[n-1]+a[n]+a[n+1] # Region I
			}

			# Judge state of each cell
			if(a[m]==1 && (sum<=1 || sum>=4)){
				b[m] = 0
			} else {
				if(a[m]==0 && sum == 3){
					b[m] = 1
				} else {
					b[m] = a[m]
				}
			}

			# Update state of cells
			if(b[m]==0){
				set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "white"
			} else {
				set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "black"
			}
		}
	}

	# Store data of new generation in a[]
	do for [x=1:N] {
		a[x] = b[x]
	}

	# Update number of generations
	set label 1 center title(k+1) font 'Times New Roman, 24' at graph 0.50, 1.03
	filename = sprintf("png/img_%04d.png",k+1)
	set output filename
	plot 1/0
}

set out