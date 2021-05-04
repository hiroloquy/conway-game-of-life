reset

#=================== Parameter ====================
Nx = 12			# Number of cells (width)
Ny = 12			# Number of cells (height)
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

array a[N]										# 配列の定義
array b[N]										# 配列の定義
title(i) = sprintf("Generations: %5d\n", i)		# 世代数カウンタの表示

# ------------------------------------------------------------------
# 乱数による各セルの初期状態の決定とプロット
# ------------------------------------------------------------------
do for [i=1:Ny] {
	do for [j=1:Nx] {
		m = Nx*(i-1)+j
		if(m==5||m==6||m==17||m==18||m==41||m==42||m==43||m==44||m==52||\
m==57||m==59||m==60||m==64||m==66||m==69||m==71||m==72||m==73||m==74||m==76||\
m==78||m==81||m==85||m==86||m==88||m==91||m==93||m==101||m==102||m==103||m==104||\
m==127||m==128||m==139||m==140){
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

#set label 1 center title(1) font 'Times New Roman, 24' at graph 0.50, 1.03
filename = sprintf("png/img_%04d.png",1)
set output filename
plot 1/0

# ------------------------------------------------------------------
# プロット
# ------------------------------------------------------------------
do for [k=1:200-1] {
	do for [i=1:Ny] {
		do for [j=1:Nx] {
			l = Nx*(i-2)+j		# 中央下
			m = Nx*(i-1)+j		# 中央
			n = Nx*i+j			# 中央上

			# 近傍8個のセルで生きているセルの数を数える
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

			# ルールによる生死の判定
			if(a[m]==1 && (sum<=1 || sum>=4)){
				b[m] = 0
			} else {
				if(a[m]==0 && sum == 3){
					b[m] = 1
				} else {
					b[m] = a[m]
				}
			}

			# 状態の更新
			if(b[m]==0){
				set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "white"
			} else {
				set object m rectangle from j-1, i-1 to j, i lw 1 fc rgb "black"
			}
		}
	}

	do for [x=1:N] {
		a[x] = b[x]
	}

	#set label 1 center title(k+1) font 'Times New Roman, 24' at graph 0.50, 1.03
	filename = sprintf("png/img_%04d.png",k+1)
	set output filename
	plot 1/0
}

set out