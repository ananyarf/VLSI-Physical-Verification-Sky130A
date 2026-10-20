v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1030 -1370 1030 -1340 {lab=vdd}
N 1030 -1280 1030 -1230 {lab=out}
N 1030 -1170 1030 -1120 {lab=vss}
N 1030 -1250 1130 -1250 {lab=out}
N 980 -1310 990 -1310 {lab=in}
N 980 -1310 980 -1200 {lab=in}
N 980 -1200 990 -1200 {lab=in}
N 950 -1250 980 -1250 {lab=in}
N 1030 -1200 1050 -1200 {lab=vss}
N 1050 -1200 1050 -1150 {lab=vss}
N 1030 -1150 1050 -1150 {lab=vss}
N 1030 -1310 1050 -1310 {lab=vdd}
N 1050 -1350 1050 -1310 {lab=vdd}
N 1030 -1350 1050 -1350 {lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 1010 -1200 0 0 {name=M1
W=4.5
L=0.18
nf=3
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1010 -1310 0 0 {name=M2
W=3
L=0.18
nf=3
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {ipin.sym} 950 -1250 0 0 {name=p1 lab=in}
C {opin.sym} 1130 -1250 0 0 {name=p2 lab=out}
C {iopin.sym} 1030 -1370 0 0 {name=p3 lab=vdd
}
C {iopin.sym} 1030 -1120 0 0 {name=p4 lab=vss}
