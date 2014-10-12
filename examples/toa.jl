function g_pot(latitude, longitude, d_, t_)

standardmeridian=longitude

localstandardtime=t_
tthet=2*pi*(d_-1.0)/365.0

eqoftime=(0.000075+0.001868*cos(tthet)-0.032077*sin(tthet)-0.014615*cos(2*tthet)-0.040849*sin(2*tthet))*229.18

localapparentsolartime=localstandardtime+eqoftime/60+longitude/15
signedLAS=12-localapparentsolartime

signedLAS=abs(signedLAS)
omega= -15*signedLAS

decl_rad=0.006918-0.399912*cos(tthet)+0.070257*sin(tthet)-0.006758*cos(2*tthet)+0.000907*sin(2*tthet)-0.002697*cos(3*tthet)+0.00148*sin(3*tthet)
decl=decl_rad*180/pi
lat_rad=latitude*pi/180
long_rad=longitude*pi/180


theta_rad=acos(sin(decl_rad)*sin(lat_rad)+cos(decl_rad)*cos(lat_rad)*cos(omega*pi/180.))

theta=theta_rad/pi*180
beta=90-theta
beta_rad=beta*pi/180

dt=d_+t_/24

solarconst=1376

Rpot=solarconst*(1.00011+0.034221*cos(tthet)+0.00128*sin(tthet)+0.000719*cos(2*tthet)+0.000077*sin(2*tthet))

Rpot_h=Rpot*cos(theta_rad)
Rpot_h = cos(theta_rad)<0.0 ? 0.0 : Rpot_h
return(Rpot_h)
end
