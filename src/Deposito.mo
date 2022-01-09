package Deposito
    import SI = Modelica.SIunits;
    import Modelica.Math.*;
    import Modelica.Blocks.Math.*;

    package Interfaces
        connector Liquido
            SI.MassFlowRate     Fm        "Flujo masico";
        end Liquido;
        connector EValvula
            Integer s                "Estado de la valvula";
        end EValvula;
        connector Signal
            Real  s;
        end Signal;
        connector Altura
            SI.Height  h;
        end Altura;
    end Interfaces;

    package Componentes
        model Valvula
            constant Real       pi = 2 * Modelica.Math.asin(1.0);  // 3.14159265358979;
            Interfaces.EValvula   av1;
            Interfaces.EValvula   av2;
            equation
            av1.s      = 0.5*sign(-sin(pi*time/30))+0.5;
            av2.s      = 0.5*sign(sin(pi*time/30))+0.5;
        end Valvula;

        model Fuente
            Interfaces.Signal u;
            Interfaces.Liquido Fin;
            parameter Real      B  (unit="m3/(s.V)")  "Parametro de la bomba";
            equation
                Fin.Fm      = B * min(20,max(0,u.s));
        end Fuente;

    model Deposito
        Interfaces.Liquido Fin;
        Interfaces.Liquido Fout1;
        Interfaces.Liquido Fout2;
        Interfaces.Altura h;
        parameter SI.Area   A      "Sección del deposito";
    
        equation
        der(h.h) = (Fin.Fm - Fout1.Fm - Fout2.Fm)/A;
    end Deposito;

        model Salida
            Interfaces.Liquido  Fout;
            Interfaces.Altura h; //altura del liquido
            parameter SI.Height hv; //altura de la valvula
            Interfaces.EValvula av; //estado de la valvula
            parameter Real      K  (unit="mm")          "Parametro de la tuberia";
            algorithm
            Fout.Fm    := if av.s<=0 
                            then 0
                        else
                            if h.h<=hv
                                then 0 
                                else K*av.s*sqrt(h.h-hv);
        end Salida;
    
        model ConsignaNivel
            Interfaces.Altura hsp;
            equation
            hsp.h = if time < 60 
                    then 5 
                    else if  time >=60 and time < 120 
                            then (time+30)/30 
                    else if time >= 120 and time <180 
                            then (-time+270)/30 
                    else 5;
        end ConsignaNivel;

        model ControladorPI
            Interfaces.Signal u;
            Interfaces.Altura hsp;
            Interfaces.Altura h;
            parameter Real    kP "Parametro proporcional  del controlador";
            parameter Real    kI "Param. integral controlador";
            protected
                SI.Position   e  "href-h,calculado en el controlador";
                Real          I  (unit="m.s", start=0, fixed=true) "Integral del error";
            equation
                e        = hsp.h - h.h;
                der(I)   = e;
                u.s      = kP*e + I/kI;
        end ControladorPI;

    end Componentes;

    model Control
        import Deposito.Componentes.*;
        parameter Real      kf (unit="kg/(s.V)") = 100 "Parametro de la fuente";
        parameter Real      kI (unit="m.s/V") = 10 "Param. integral controlador";
        parameter Real      kP (unit="V/m") = 5    "Param. proporcional controlador";
        parameter SI.Height h1 = 4.0     "Altura de la salida 1";
        parameter SI.Height h2 = 1.5   "Altura de la salida 2";
        parameter Real      B  (unit="m3/(s.V)") =0.3  "Parametro de la bomba";
        parameter Real      K  (unit="mm") = 5          "Parametro de la tuberia";
        parameter SI.Area   A  = 2     "Sección del deposito";
        Deposito      deposito(A=A);
        Fuente        fuente  (B=B);
        ControladorPI LC      (kI=kI,kP=kP);
        ConsignaNivel nivelSP;
        Salida        salida1 (hv=h1,K=K);
        Salida        salida2 (hv=h2,K=K);
        Valvula       valvulas;
        equation
            connect(nivelSP.hsp, LC.hsp);//nivel con controlador
            connect(deposito.Fin,fuente.Fin);
            connect(deposito.Fout1,salida1.Fout);
            connect(deposito.Fout2,salida2.Fout);
            connect(salida1.av,valvulas.av1);
            connect(salida1.h,deposito.h);
            connect(salida2.av,valvulas.av2);
            connect(salida2.h,deposito.h);
            connect(LC.u,fuente.u); //controlador con la fuente
            connect(LC.h,deposito.h);
    end Control;
end Deposito;
