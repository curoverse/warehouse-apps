# Fetch data files before running this:
#  cd /tmp
#  for m in \
#  e360ecc2fb53790628bc990fc6568f00 \
#  a7c1c32fd653dd069bd9a17740f58e83 \
#  8b0d68956d7b747e816c0f1f1fb25d40 \
#  31e81993fe9a19104d864f56f5ed7155 \
#  d3323e14a7bb07d0ea058a144cfbe856 \
#  611289629595e6331701b3ac2a74319f \
#  b0e21209c3ccc04f33d32498ec3b8a67
#  do
#   wget http://genomerator-dev.freelogy.org/pgp10factory/allstats.cgi?$m -q -O $m
#   md5sum $m
#  done
#  wget http://tomc.freelogy.org/~tomc/pgp10/snploci-stats
#  wget http://tomc.freelogy.org/~tomc/pgp10/snploci-stats-2s3c
#  wget http://tomc.freelogy.org/~tomc/pgp10/snploci-stats-2s3c-hg18
# Then:
#  R --no-save < /path/to/pgp10pipelines.r

T_1s_1c <- read.delim("e360ecc2fb53790628bc990fc6568f00",header=TRUE)[1:10,]
T_1s_3c <- read.delim("a7c1c32fd653dd069bd9a17740f58e83",header=TRUE)[1:10,]
T_2s_3c <- read.delim("8b0d68956d7b747e816c0f1f1fb25d40",header=TRUE)[1:10,]
T_1s_1c_hg18 <- read.delim("31e81993fe9a19104d864f56f5ed7155",header=TRUE)[1:10,]
T_1s_3c_hg18 <- read.delim("d3323e14a7bb07d0ea058a144cfbe856",header=TRUE)[1:10,]
T_2s_3c_hg18 <- read.delim("611289629595e6331701b3ac2a74319f",header=TRUE)[1:10,]
T_public <- read.delim("b0e21209c3ccc04f33d32498ec3b8a67",header=TRUE)[1:10,]
snploci <- read.delim("snploci-stats",header=TRUE)
snploci_2s3c <- read.delim("snploci-stats-2s3c",header=TRUE)
snploci_2s3c_hg18 <- read.delim("snploci-stats-2s3c-hg18",header=TRUE)

Allstats <- T_1s_1c
Allstats <- merge(Allstats, T_1s_1c, by="X", suffixes=c("",".1s_1c"), sort=FALSE)
Allstats <- merge(Allstats, T_1s_3c, by="X", suffixes=c("",".1s_3c"), sort=FALSE)
Allstats <- merge(Allstats, T_2s_3c, by="X", suffixes=c("",".2s_3c"), sort=FALSE)
Allstats <- merge(Allstats, T_1s_1c_hg18, by="X", suffixes=c("",".1s_1c_hg18"), sort=FALSE)
Allstats <- merge(Allstats, T_1s_3c_hg18, by="X", suffixes=c("",".1s_3c_hg18"), sort=FALSE)
Allstats <- merge(Allstats, T_2s_3c_hg18, by="X", suffixes=c("",".2s_3c_hg18"), sort=FALSE)
Allstats <- merge(Allstats, T_public, by="X", suffixes=c("",".public"), sort=FALSE)

postscript(file="/tmp/placed-vs-reads.ps",
	   title="/tmp/placed-vs-reads.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     t(T_2s_3c[,"places"])*36,
     xlab="Bases input",
     ylab="Bases placed")

postscript(file="/tmp/covered-vs-reads.ps",
	   title="/tmp/covered-vs-reads.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     t(T_2s_3c[,"covers"]),
     ylim=c(0,6743440),
     xlab="Bases input",
     ylab="Loci covered")

postscript(file="/tmp/placed-vs-reads.ps",
	   title="/tmp/placed-vs-reads.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     t(T_2s_3c[,"places"])*36,
     xlab="Bases input",
     ylab="Bases placed")

postscript(file="/tmp/coverage-est-vs-reads-1s1c.ps",
	   title="/tmp/coverage-est-vs-reads-1s1c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
     / (Allstats[,"con.1s_1c"]+
	Allstats[,"dis.1s_1c"]+
	Allstats[,"nocall.1s_1c"]),
     ylim=c(0,6743440),
     xlab="Bases input",
     ylab="Loci covered")

postscript(file="/tmp/coverage-est-vs-reads-1s3c.ps",
	   title="/tmp/coverage-est-vs-reads-1s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
     / (Allstats[,"con.1s_3c"]+
	Allstats[,"dis.1s_3c"]+
	Allstats[,"nocall.1s_3c"]),
     ylim=c(0,6743440),
     xlab="Bases input",
     ylab="Loci covered")

postscript(file="/tmp/coverage-est-vs-reads-2s3c.ps",
	   title="/tmp/coverage-est-vs-reads-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])
     / (Allstats[,"con.2s_3c"]+
	Allstats[,"dis.2s_3c"]+
	Allstats[,"nocall.2s_3c"]),
     ylim=c(0,6743440),
     xlab="Bases input",
     ylab="Loci covered")

postscript(file="/tmp/coverage-est-vs-reads-all.ps",
	   title="/tmp/coverage-est-vs-reads-all.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])
     / (Allstats[,"con.2s_3c"]+
	Allstats[,"dis.2s_3c"]+
	Allstats[,"nocall.2s_3c"]),
     pch=8,
     ylim=c(0,6743440),
     xlab="Bases input",
     ylab="Loci covered")
symbols(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
     / (Allstats[,"con.1s_3c"]+
	Allstats[,"dis.1s_3c"]+
	Allstats[,"nocall.1s_3c"]),
	squares=rep(1,10),
	ylim=c(0,6743440),
	add=TRUE, xlab="", ylab="", inches=0.08)
symbols(t(T_2s_3c[,"reads"])*36,
     6743440
     * (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
     / (Allstats[,"con.1s_1c"]+
	Allstats[,"dis.1s_1c"]+
	Allstats[,"nocall.1s_1c"]),
	circles=rep(1,10),
	ylim=c(0,6743440),
	add=TRUE, xlab="", ylab="", inches=0.04)

postscript(file="/tmp/coverage-est-vs-places-all.ps",
	   title="/tmp/coverage-est-vs-places-all.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
plot(t(T_2s_3c[,"places"])*36,
     6743440
     * (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])
     / (Allstats[,"con.2s_3c"]+
	Allstats[,"dis.2s_3c"]+
	Allstats[,"nocall.2s_3c"]),
     pch=8,
     ylim=c(0,6743440),
     xlab="Bases placed",
     ylab="Loci covered")
symbols(t(T_2s_3c[,"places"])*36,
     6743440
     * (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
     / (Allstats[,"con.1s_3c"]+
	Allstats[,"dis.1s_3c"]+
	Allstats[,"nocall.1s_3c"]),
	squares=rep(1,10),
	ylim=c(0,6743440),
	add=TRUE, xlab="", ylab="", inches=0.08)
symbols(t(T_2s_3c[,"places"])*36,
     6743440
     * (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
     / (Allstats[,"con.1s_1c"]+
	Allstats[,"dis.1s_1c"]+
	Allstats[,"nocall.1s_1c"]),
	circles=rep(1,10),
	ylim=c(0,6743440),
	add=TRUE, xlab="", ylab="", inches=0.04)

postscript(file="/tmp/con-dis-nocall-1s1c.ps",
	   title="/tmp/con-dis-nocall-1s1c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_1s_1c[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall")

postscript(file="/tmp/con-dis-nocall-1s3c.ps",
	   title="/tmp/con-dis-nocall-1s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_1s_3c[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall")

postscript(file="/tmp/con-dis-nocall-2s3c.ps",
	   title="/tmp/con-dis-nocall-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_2s_3c[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall")

postscript(file="/tmp/con-dis-nocall-1s1c-hg18.ps",
	   title="/tmp/con-dis-nocall-1s1c-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_1s_1c_hg18[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall")

postscript(file="/tmp/con-dis-nocall-1s3c-hg18.ps",
	   title="/tmp/con-dis-nocall-1s3c-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_1s_3c_hg18[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall")

postscript(file="/tmp/con-dis-nocall-2s3c-hg18.ps",
	   title="/tmp/con-dis-nocall-2s3c-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")
barplot(t(T_2s_3c_hg18[,c("con","dis","nocall")]),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall");



postscript(file="/tmp/filter-effect-55k.ps",
	   title="/tmp/filter-effect-55k.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("con.1s_1c","dis.1s_1c","nocall.1s_1c")]
foo[11:20,] <- Allstats[,c("con.1s_3c","dis.1s_3c","nocall.1s_3c")]
foo[21:30,] <- Allstats[,c("con.2s_3c","dis.2s_3c","nocall.2s_3c")]

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10))),]),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8,.5,1)),
	ylab="concordant - discordant - nocall",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)



postscript(file="/tmp/filter-effect-hg18.ps",
	   title="/tmp/filter-effect-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("con.1s_1c_hg18","dis.1s_1c_hg18","nocall.1s_1c_hg18")]
foo[11:20,] <- Allstats[,c("con.1s_3c_hg18","dis.1s_3c_hg18","nocall.1s_3c_hg18")]
foo[21:30,] <- Allstats[,c("con.2s_3c_hg18","dis.2s_3c_hg18","nocall.2s_3c_hg18")]

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10))),]),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant, nocall",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)



postscript(file="/tmp/reference-effect-2s3c.ps",
	   title="/tmp/reference-effect-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("con.2s_3c","dis.2s_3c")]
foo[11:20,] <- Allstats[,c("con.2s_3c_hg18","dis.2s_3c_hg18")]

barplot(t(foo[ order(c(2*(1:10)-1, 2*(1:10))), ]),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8,.5,1)),
	ylab="concordant, discordant",
	xlab="55k, hg18",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-on-het-and-dbsnp.ps",
	   title="/tmp/filter-effect-on-het-and-dbsnp.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("het.y.1s_1c","hom.y.1s_1c","het.n.1s_1c","hom.n.1s_1c")]
foo[11:20,] <- Allstats[,c("het.y.1s_3c","hom.y.1s_3c","het.n.1s_3c","hom.n.1s_3c")]
foo[21:30,] <- Allstats[,c("het.y.2s_3c","hom.y.2s_3c","het.n.2s_3c","hom.n.2s_3c")]

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10))),]),
	ylim=c(0,10000),
	space=c(0,rep(c(0,0,1),9),0,0),
	ylab="het,dbsnp - hom,dbsnp - het,other - hom,other",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-on-het-and-dbsnp-hg18.ps",
	   title="/tmp/filter-effect-on-het-and-dbsnp-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("het.y.1s_1c_hg18","hom.y.1s_1c_hg18","het.n.1s_1c_hg18","hom.n.1s_1c_hg18")]
foo[11:20,] <- Allstats[,c("het.y.1s_3c_hg18","hom.y.1s_3c_hg18","het.n.1s_3c_hg18","hom.n.1s_3c_hg18")]
foo[21:30,] <- Allstats[,c("het.y.2s_3c_hg18","hom.y.2s_3c_hg18","het.n.2s_3c_hg18","hom.n.2s_3c_hg18")]

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10))),]),
	ylim=c(0,10000),
	space=c(0,rep(c(0,0,1),9),0,0),
	ylab="het,dbsnp - hom,dbsnp - het,other - hom,other",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-on-het-and-dbsnp-proportion.ps",
	   title="/tmp/filter-effect-on-het-and-dbsnp-proportion.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("het.y.1s_1c","hom.y.1s_1c","het.n.1s_1c","hom.n.1s_1c")]
foo[11:20,] <- Allstats[,c("het.y.1s_3c","hom.y.1s_3c","het.n.1s_3c","hom.n.1s_3c")]
foo[21:30,] <- Allstats[,c("het.y.2s_3c","hom.y.2s_3c","het.n.2s_3c","hom.n.2s_3c")]
foo <- foo/rowSums(foo)

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10))),]),
	space=c(0,rep(c(0,0,1),9),0,0),
	ylab="proportion of het/dbsnp, hom/dbsnp, het/other, hom/other",
	xlab="1s1c/1s3c/2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-on-het-and-dbsnp-proportion-grouped.ps",
	   title="/tmp/filter-effect-on-het-and-dbsnp-proportion-grouped.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

dbsnp_order <- order(rowSums(Allstats[,c("het.y.2s_3c","hom.y.2s_3c")]/Allstats[,"call.2s_3c"]))
foo <- Allstats[dbsnp_order,c("het.y.1s_1c","hom.y.1s_1c","het.n.1s_1c","hom.n.1s_1c")]
foo[11:20,] <- Allstats[dbsnp_order,c("het.y.1s_3c","hom.y.1s_3c","het.n.1s_3c","hom.n.1s_3c")]
foo[21:30,] <- Allstats[dbsnp_order,c("het.y.2s_3c","hom.y.2s_3c","het.n.2s_3c","hom.n.2s_3c")]
foo <- foo/rowSums(foo)

barplot(t(foo),
	space=c(0,rep(c(0,0,0,0,0,0,0,0,0,1),2),0,0,0,0,0,0,0,0,0),
	ylab="het,dbsnp - hom,dbsnp - het,novel - hom,novel",
	xlab="pgp10 for each filter: 1s1c, 1s3c, 2s3c",
	xaxt="n")


postscript(file="/tmp/filter-effect-on-het-and-dbsnp-2s3c.ps",
	   title="/tmp/filter-effect-on-het-and-dbsnp-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,c("het.y.2s_3c","hom.y.2s_3c","het.n.2s_3c","hom.n.2s_3c")]

barplot(t(foo),
	ylab="het,dbsnp - hom,dbsnp - het,novel - hom,novel",
	space=0.2,
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*1.2-.5,
     tick=FALSE)


postscript(file="/tmp/het-and-dbsnp-public.ps",
	   title="/tmp/het-and-dbsnp-public.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

barplot(t(snploci[,c("het.y","hom.y","het.n","hom.n")]),
	ylim=c(0,5500),
	ylab="het,dbsnp - hom,dbsnp - het,novel - hom,novel",
	space=0.2,
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*1.2-.5,
     tick=FALSE)


postscript(file="/tmp/het-and-dbsnp-2s3c.ps",
	   title="/tmp/het-and-dbsnp-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

barplot(t(snploci_2s3c[,c("het.y","hom.y","het.n","hom.n")]),
	ylim=c(0,5500),
	ylab="het,dbsnp - hom,dbsnp - het,novel - hom,novel",
	space=0.2,
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*1.2-.5,
     tick=FALSE)


postscript(file="/tmp/het-and-dbsnp-2s3c-hg18.ps",
	   title="/tmp/het-and-dbsnp-2s3c-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

barplot(t(snploci_2s3c_hg18[,c("het.y","hom.y","het.n","hom.n")]),
	ylim=c(0,5500),
	ylab="het,dbsnp - hom,dbsnp - het,novel - hom,novel",
	space=0.2,
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*1.2-.5,
     tick=FALSE)


postscript(file="/tmp/dbsnp-novel-2s3c.ps",
	   title="/tmp/dbsnp-novel-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- snploci_2s3c[,c("het.y","hom.y")]
foo[11:20,] <- snploci_2s3c[,c("het.n","hom.n")]
barplot(t(foo[order(c(2*(1:10)-1,2*(1:10))),]),
	ylim=c(0,3000),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8,.5)),
	ylab="heterozygous, homozygous",
	xlab="dbSNP, novel",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2,
     tick=FALSE)


postscript(file="/tmp/dbsnp-novel-2s3c-proportion.ps",
	   title="/tmp/dbsnp-novel-2s3c-proportion.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- snploci_2s3c[,c("het.y","hom.y")]
foo[11:20,] <- snploci_2s3c[,c("het.n","hom.n")]
foo <- 100 * foo/rowSums(foo)
barplot(t(foo[order(c(2*(1:10)-1,2*(1:10))),"het.y"]),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8,.5)),
	ylab="% heterozygous",
	xlab="dbSNP, novel",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2,
     tick=FALSE)


postscript(file="/tmp/het-proportion-agreement-1s1c.ps",
	   title="/tmp/het-proportion-agreement-1s1c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"het.y.1s_1c"]/(Allstats[,"het.y.1s_1c"]+Allstats[,"hom.y.1s_1c"])
foo[11:20] <- Allstats[,"het.n.1s_1c"]/(Allstats[,"het.n.1s_1c"]+Allstats[,"hom.n.1s_1c"])

barplot(t(foo[order(c(2*(1:10)-1,2*(1:10)))]),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8)),
	ylab="proportion of heterozygous SNPs",
	xlab="Compare loci in dbSNP / not in dbSNP for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2,
     tick=FALSE)


postscript(file="/tmp/het-proportion-agreement-1s3c.ps",
	   title="/tmp/het-proportion-agreement-1s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"het.y.1s_3c"]/(Allstats[,"het.y.1s_3c"]+Allstats[,"hom.y.1s_3c"])
foo[11:20] <- Allstats[,"het.n.1s_3c"]/(Allstats[,"het.n.1s_3c"]+Allstats[,"hom.n.1s_3c"])

barplot(t(foo[order(c(2*(1:10)-1,2*(1:10)))]),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8)),
	ylab="proportion of heterozygous SNPs",
	xlab="Compare loci in dbSNP / not in dbSNP for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2,
     tick=FALSE)


postscript(file="/tmp/het-proportion-agreement-2s3c.ps",
	   title="/tmp/het-proportion-agreement-2s3c.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"het.y.2s_3c"]/(Allstats[,"het.y.2s_3c"]+Allstats[,"hom.y.2s_3c"])
foo[11:20] <- Allstats[,"het.n.2s_3c"]/(Allstats[,"het.n.2s_3c"]+Allstats[,"hom.n.2s_3c"])

barplot(t(foo[order(c(2*(1:10)-1,2*(1:10)))]),
	space=c(0,rep(c(0,1),9),0),
	col=gray(c(.8)),
	ylab="proportion of heterozygous SNPs",
	xlab="Compare loci in dbSNP / not in dbSNP for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*3-2,
     tick=FALSE)


postscript(file="/tmp/filter-effect-percent.ps",
	   title="/tmp/filter-effect-percent.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"con.1s_1c"]/(Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
foo[11:20] <- Allstats[,"con.1s_3c"]/(Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
foo[21:30] <- Allstats[,"con.2s_3c"]/(Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])
foo <- foo * 100

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))]),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8)),
	ylab="% concordance with Affy scans",
	xlab="1s1c/1s3c/2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-percent-hg18.ps",
	   title="/tmp/filter-effect-percent-hg18.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"con.1s_1c_hg18"]/(Allstats[,"con.1s_1c_hg18"]+Allstats[,"dis.1s_1c_hg18"])
foo[11:20] <- Allstats[,"con.1s_3c_hg18"]/(Allstats[,"con.1s_3c_hg18"]+Allstats[,"dis.1s_3c_hg18"])
foo[21:30] <- Allstats[,"con.2s_3c_hg18"]/(Allstats[,"con.2s_3c_hg18"]+Allstats[,"dis.2s_3c_hg18"])
foo <- foo * 100

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))]),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8)),
	ylab="% concordance with Affy scans",
	xlab="1s1c/1s3c/2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-proportion-het-in-dbsnp.ps",
	   title="/tmp/filter-effect-proportion-het-in-dbsnp.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"het.y.1s_1c"]/(Allstats[,"het.y.1s_1c"]+Allstats[,"het.n.1s_1c"])
foo[11:20] <- Allstats[,"het.y.1s_3c"]/(Allstats[,"het.y.1s_3c"]+Allstats[,"het.n.1s_3c"])
foo[21:30] <- Allstats[,"het.y.2s_3c"]/(Allstats[,"het.y.2s_3c"]+Allstats[,"het.n.2s_3c"])
foo <- foo * 100

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))]),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8)),
	ylab="% heterozygous calls appearing in dbSNP",
	xlab="1s1c/1s3c/2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)




postscript(file="/tmp/filter-effect-expected-het-rate-est.ps",
	   title="/tmp/filter-effect-expected-het-rate-est.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- (Allstats[,"het.y.1s_1c"]+Allstats[,"het.n.1s_1c"])*
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"]+Allstats[,"nocall.1s_1c"])/
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
foo[11:20] <- (Allstats[,"het.y.1s_3c"]+Allstats[,"het.n.1s_3c"])*
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"]+Allstats[,"nocall.1s_3c"])/
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
foo[21:30] <- (Allstats[,"het.y.2s_3c"]+Allstats[,"het.n.2s_3c"])*
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"]+Allstats[,"nocall.2s_3c"])/
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))]),
	ylim=c(0,5000),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8)),
	ylab="Number of heterozygous calls expected with full coverage",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-expected-het-rate-maqstat.ps",
	   title="/tmp/filter-effect-expected-het-rate-maqstat.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- (Allstats[,"het.y.1s_1c"]+Allstats[,"het.n.1s_1c"]) * 6743440 / Allstats[,"covers.1s_1c"]
foo[11:20] <- (Allstats[,"het.y.1s_3c"]+Allstats[,"het.n.1s_3c"]) * 6743440 / Allstats[,"covers.1s_1c"]
foo[21:30] <- (Allstats[,"het.y.2s_3c"]+Allstats[,"het.n.2s_3c"]) * 6743440 / Allstats[,"covers.1s_1c"]

barplot(t(foo[order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))]),
	ylim=c(0,5000),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8)),
	ylab="Number of heterozygous calls expected with full coverage",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-expected-het-rate-est-dbsnp-novel.ps",
	   title="/tmp/filter-effect-expected-het-rate-est-dbsnp-novel.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

dbsnp <- (Allstats[,"het.y.1s_1c"])*
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"]+Allstats[,"nocall.1s_1c"])/
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
novel <- (Allstats[,"het.n.1s_1c"])*
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"]+Allstats[,"nocall.1s_1c"])/
       (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"])
dbsnp[11:20] <- (Allstats[,"het.y.1s_3c"])*
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"]+Allstats[,"nocall.1s_3c"])/
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
novel[11:20] <- (Allstats[,"het.n.1s_3c"])*
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"]+Allstats[,"nocall.1s_3c"])/
       (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"])
dbsnp[21:30] <- (Allstats[,"het.y.2s_3c"])*
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"]+Allstats[,"nocall.2s_3c"])/
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])
novel[21:30] <- (Allstats[,"het.n.2s_3c"])*
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"]+Allstats[,"nocall.2s_3c"])/
       (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"])

barplot(t(cbind(dbsnp,novel))[,order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))],
	ylim=c(0,5000),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8,.5)),
	ylab="Number of heterozygous calls expected with full coverage (dbsnp, novel)",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/filter-effect-expected-het-rate-maqstat-dbsnp-novel.ps",
	   title="/tmp/filter-effect-expected-het-rate-maqstat-dbsnp-novel.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

dbsnp <- (Allstats[,"het.y.1s_1c"])*
	6743440 / Allstats[,"covers.1s_1c"]
novel <- (Allstats[,"het.n.1s_1c"])*
	6743440 / Allstats[,"covers.1s_1c"]
dbsnp[11:20] <- (Allstats[,"het.y.1s_3c"])*
	6743440 / Allstats[,"covers.1s_1c"]
novel[11:20] <- (Allstats[,"het.n.1s_3c"])*
	6743440 / Allstats[,"covers.1s_1c"]
dbsnp[21:30] <- (Allstats[,"het.y.2s_3c"])*
	6743440 / Allstats[,"covers.1s_1c"]
novel[21:30] <- (Allstats[,"het.n.2s_3c"])*
	6743440 / Allstats[,"covers.1s_1c"]

barplot(t(cbind(dbsnp,novel))[,order(c(3*(1:10)-2,3*(1:10)-1,3*(1:10)))],
	ylim=c(0,5000),
	space=c(0,rep(c(0,0,1),9),0,0),
	col=gray(c(.8,.5)),
	ylab="Number of heterozygous calls expected with full coverage (dbsnp, novel)",
	xlab="1s1c, 1s3c, 2s3c for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*4-2.5,
     tick=FALSE)


postscript(file="/tmp/coverage-estimates.ps",
	   title="/tmp/coverage-estimates.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

foo <- Allstats[,"covers.1s_1c"]
foo[11:20] <- 6743440 * (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"]) / (Allstats[,"con.1s_1c"]+Allstats[,"dis.1s_1c"]+Allstats[,"nocall.1s_1c"])
foo[21:30] <- 6743440 * (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"]) / (Allstats[,"con.1s_3c"]+Allstats[,"dis.1s_3c"]+Allstats[,"nocall.1s_3c"])
foo[31:40] <- 6743440 * (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"]) / (Allstats[,"con.2s_3c"]+Allstats[,"dis.2s_3c"]+Allstats[,"nocall.2s_3c"])

barplot(t(foo[order(c(4*(1:10)-3,4*(1:10)-2,4*(1:10)-1,4*(1:10)))]),
	space=c(0,rep(c(0,0,0,1),9),0,0,0),
	col=gray(c(.8)),
	ylab="loci with enough coverage to make calls",
	xlab="maq statistic and 1s1c / 1s3c / 2s3c estimates for each participant",
	xaxt="n")
axis(1,
     labels=c(1:10),
     at=(1:10)*5-3,
     tick=FALSE)


postscript(file="/tmp/filter-effect-on-het-dbsnp-proportion-grouped.ps",
	   title="/tmp/filter-effect-on-het-dbsnp-proportion-grouped.ps",
	   width=6,
	   height=6,
	   horizontal=F,
	   onefile=F,
	   paper="letter")

dbsnp_order <- c(1:10)
#dbsnp_order <- order(rowSums(Allstats[,"het.y.2s_3c"]/Allstats[,c("het.y.2s_3c","het.n.2s_3c")]))
foo <- (Allstats[,"het.y.1s_1c"]/(Allstats[,"het.y.1s_1c"]+Allstats[,"het.n.1s_1c"]))[dbsnp_order]
foo[11:20] <-(Allstats[,"het.y.1s_3c"]/(Allstats[,"het.y.1s_3c"]+Allstats[,"het.n.1s_3c"]))[dbsnp_order]
foo[21:30] <-(Allstats[,"het.y.2s_3c"]/(Allstats[,"het.y.2s_3c"]+Allstats[,"het.n.2s_3c"]))[dbsnp_order]

barplot(t(foo),
	space=c(0,rep(c(0,0,0,0,0,0,0,0,0,1),2),0,0,0,0,0,0,0,0,0),
	col=gray(c(.8)),
	ylab="proportion of heterozygous calls appearing in dbSNP",
	xlab="pgp10 for each filter: 1s1c, 1s3c, 2s3c",
	xaxt="n")
