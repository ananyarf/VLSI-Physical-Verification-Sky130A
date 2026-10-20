v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -160 -30 -110 -30 {lab=in}
N -230 30 -160 30 {lab=GND}
N -160 30 190 30 {lab=GND}
N 190 10 190 30 {lab=GND}
N -230 -50 -230 -30 {lab=#net1}
N -230 -50 190 -50 {lab=#net1}
N 190 -50 190 -30 {lab=#net1}
N -140 -80 -140 -30 {lab=in}
N 190 -10 220 -10 {lab=out}
C {inverter_1.sym} 40 -10 0 0 {name=x1}
C {vsource.sym} -160 0 0 0 {name=V1 value="PULSE(0 1.8 0 100p 100p 5n 10n" savecurrent=false}
C {vsource.sym} -230 0 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} -50 30 0 0 {name=l1 lab=GND}
C {opin.sym} 220 -10 0 0 {name=p1 lab=out}
C {ipin.sym} -140 -80 0 0 {name=p2 lab=in}
C {code_shown.sym} 0 -130 0 0 {name=s1 only_toplevel=false value=".lib /home/ananya/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {code_shown.sym} 0 100 0 0 {name=s2 only_toplevel=false value=".control
tran 10p 40n 
plot V(in) V(out)
.endc"}
