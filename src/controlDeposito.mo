model ControlDeposito
  import SI = Modelica.SIunits;
  import Modelica.Math.*;
  import Modelica.Blocks.Math.*;
  SI.Position         e          "href-h,calculado en el controlador";
  SI.MassFlowRate     Fin        "Flujo masico de entrada al deposito";
  SI.MassFlowRate     Fout1      "Flujo masico de salida del deposito 1";
  SI.MassFlowRate     Fout2      "Flujo masico de salida del deposito 2";
  Integer             av1        "Estado de la valvula 1 0=cerrada 1=abierta";
  Integer             av2        "Estado de la valvula 2 0=cerrada 1=abierta";
  Real                I  (unit="m.s", start=0, fixed=true) "Integral del error";
  SI.Height           h  (start=0.5, fixed=true) "Nivel en el depósito";
  SI.Height           hsp        "Consigna para el nivel";
  constant Real       pi = 2 * Modelica.Math.asin(1.0);  // 3.14159265358979;
  parameter SI.Area   A  = 2     "Sección del deposito";
  parameter SI.Height h1 = 4     "Altura de la salida 1";
  parameter SI.Height h2 = 1.5   "Altura de la salida 2";
  parameter Real      K  (unit="mm") =5          "Parametro de la tuberia";
  parameter Real      B  (unit="m3/(s.V)") =0.3  "Parametro de la bomba";
  parameter Real      kf (unit="kg/(s.V)") = 100 "Parametro de la fuente";
  parameter Real      kI (unit="m.s/V") = 10 "Param. integral controlador";
  parameter Real      kP (unit="V/m") = 5    "Param. proporcional controlador";
  SI.Voltage          u          "Voltaje de salida del controlador";
  equation
    A*der(h) = Fin - (Fout1+Fout2);
    Fin      = B * min(20,max(0,u));
    Fout1    = if av1 <= 0 
                  then 0
                  else
                      if h<=h1 
                          then 0 
                          else K*av1*sqrt(h-h1);
    Fout2    = if av2 <= 0 
                  then 0
                  else
                      if h<=h2 
                          then 0
                          else K*av2*sqrt(h-h2);
    av1      = 0.5*sign(-sin(pi*time/30))+0.5;
    av2      = 0.5*sign(sin(pi*time/30))+0.5;
    e        = hsp - h;
    der(I)   = e;
    u        = kP*e + I/kI;
    hsp      = if time < 60 
                  then 5 
                  else if  time >=60 and time < 120 
                        then (time+30)/30 
                  else if time >= 120 and time <180 
                        then (-time+270)/30 
                  else 5;
end ControlDeposito;
