v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -130 -80 -30 -80 {lab=#net1}
N -130 -80 -130 -30 {lab=#net1}
N -200 -10 -130 -10 {lab=in}
N -130 10 -130 50 {lab=GND}
N -200 50 -0 50 {lab=GND}
N 30 -80 210 -80 {lab=GND}
N 210 -80 210 50 {lab=GND}
N -0 50 210 50 {lab=GND}
N -170 -30 -170 -10 {lab=in}
C {vsource.sym} 0 -80 3 0 {name=VDD value=1.8 savecurrent=false}
C {vsource.sym} -200 20 0 0 {name=Vin value= 0
 savecurrent=false}
C {gnd.sym} 0 50 0 0 {name=l1 lab=GND}
C {opin.sym} 170 -30 0 0 {name=p1 lab=out}
C {ipin.sym} -170 -30 1 0 {name=p2 lab=in}
C {code_shown.sym} -140 -270 0 0 {name=s1 only_toplevel=false 
value= ".dc Vin 0 1.8 0.01 
.save_all"

}
C {sky130_fd_pr/corner.sym} 240 -300 0 0 {name=CORNER only_toplevel=false corner=tt}
C {inverter.sym} 20 -10 0 0 {name=x1}
