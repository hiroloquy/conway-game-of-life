reset

#=================== Parameter ====================
Nx = 15			# Number of cells (width)
Ny = 15			# Number of cells (height)
N = Nx*Ny		# Number of cells

#=================== Setting ====================
# set terminal png enhanced font "Times" 20 size 986, 554
set terminal png enhanced font "Times" 20 size 160*Nx/4., 160*Ny/4.
system 'mkdir png'
unset key
unset border
set xr[0:Nx]
set yr[0:Ny]
unset xtics
unset ytics
set size ratio 1
unset grid

array a[N]										# Old generation
array b[N]										# New generation
gen(i) = sprintf("Generations: %5d\n", i)		# Counter

#=================== Draw initiate state using random ====================
do for [i=1:Ny] {
	do for [j=1:Nx] {
		m = Nx*(i-1)+j
		if(m==49||m==50||m==51||m==52||m==53||m==54||m==56||m==57||m==64||m==65||m==66||m==67||m==68||m==69||m==71||m==72||m==86||m==87||m==94||m==95||m==101||m==102||m==109||m==110||m==116||m==117||m==124||m==125||m==131||m==132||m==139||m==140||m==154||m==155||m==157||m==158||m==159||m==160||m==161||m==162||m==169||m==170||m==172||m==173||m==174||m==175||m==176||m==177){
			a[m] = 1
		} else {
			a[m] = 0
		}

		if(a[m]==0){
			set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "white"
		} else {
			set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "black"
		}
	}
}

# Draw number of generations
# set label 1 center title(1) font 'Times New Roman, 24' at graph 0.50, 1.03
filename = sprintf("png/img_%04d.png",1)
set output filename
plot 1/0

#=================== Plot ====================
do for [k=1:200-1] {
	do for [i=1:Ny] {
		do for [j=1:Nx] {
			l = Nx*(i-2)+j		# Lower column
			m = Nx*(i-1)+j		# Column focused on
			n = Nx*i+j			# Upper column

			# Count statuses of cell(a[m])'s neighbors
			if(i==1){
				if(j==1){
					sum = a[2]+a[Nx+1]+a[Nx+2]
				} else {if(j==Nx){
					sum = a[Nx-1]+a[2*Nx-1]+a[2*Nx]
				} else {
					sum = a[m-1]+a[m+1]+a[n-1]+a[n]+a[n+1]
				}}
			}
			if(i==Ny){
				if(j==1){
					sum = a[Nx*(Ny-2)+1]+a[Nx*(Ny-2)+2]+a[Nx*(Ny-1)+2]
				} else {if(j==Nx){
					sum = a[Nx*(Ny-1)-1]+a[Nx*(Ny-1)]+a[Nx*Ny-1]
				} else {
					sum = a[l-1]+a[l]+a[l+1]+a[m-1]+a[m+1]
				}}
			}
			if(j==1 && (i!=1 && i!=Ny)){
				sum = a[l]+a[l+1]+a[m+1]+a[n]+a[n+1]
			}
			if(j==Nx && (i!=1 && i!=Ny)){
				sum = a[l-1]+a[l]+a[m-1]+a[n-1]+a[n]
			}
			if((j>1 && j<Nx) && (i>1 && i<Ny)) {
				sum = a[l-1]+a[l]+a[l+1]+a[m-1]+a[m+1]+a[n-1]+a[n]+a[n+1]
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
	# set label 1 center title(k+1) font 'Times New Roman, 24' at graph 0.50, 1.03
	filename = sprintf("png/img_%04d.png",k+1)
	set output filename
	plot 1/0
}

set out