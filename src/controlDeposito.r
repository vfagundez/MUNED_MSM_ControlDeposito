t_fin <- 240 # Valor final del tiempo
h     <- 0.01 # Tamaño del paso de integración
t_com <- 0.5 # Intervalo de comunicación
# Parámetros
    A  <- 2
    h1 <- 4
    h2 <- 1.5
    K  <- 0.5
    B  <- 0.3
    kp <- 5
    kI <- 10
# Inicialización del tiempo
    t  <- 0
# Valor inicial del estado
    hr <- 0.5
    I  <- 0
# Inicialización resultados salida
    t_plot      <- numeric(0)
    hsp_plot    <- numeric(0)
    hr_plot     <- numeric(0)
    av1_plot    <- numeric(0)
    av2_plot    <- numeric(0)
    e_plot      <- numeric(0)
    u_plot      <- numeric(0)
    Fin_plot    <- numeric(0)
    Fout1_plot  <- numeric(0)
    Fout2_plot  <- numeric(0)
    t_ultimaCom <- -Inf
# Bucle de la simulación
termina <- FALSE
while ( !termina ) {
termina <- (t + h/2 > t_fin)
# Cálculo variables algebraicas en t
#    Calculo de la altura de referencia hsp
if(t<60){
    hsp<-5
}else if(t>=60 && t<120){
    hsp<-(t+30)/30
}else if(t>=120&&t<180){
    hsp<-(-t+270)/30
}else{
    hsp<-5
}
#    Calculo del estado de la valvula 1
    av1<-0.5*sign(-sin(pi*t/30))+0.5
#    Calculo del estado de la valvula 1
    av2<-0.5*sign(sin(pi*t/30))+0.5
#    Calculo del error de control
    e<-(hsp-hr)
#    Calculo de la salida del controlador
    u<-(kp*e+I/kI)
#    Calculo del Flujo de entrada
    Fin<-B*min(20,max(0,u))
#    Calculo del Flujo de salida 1
    if(av1<=0){
        Fout1<-0
    }else{
        if(hr<=h1){
            Fout1<-0
        }else{
            Fout1<-K*av1*sqrt(hr-h1)
        }
    }
#    Calculo del Flujo de salida 2
    if(av2<=0){
        Fout2<-0
    }else{
        if(hr<=h2){
            Fout2<-0
        }else{
            Fout2<-K*av2*sqrt(hr-h2)
        }
    }
#    Calculo de derI
    derI<-e1
#   Calculo de derh
    derh<-(Fin-Fout1-Fout2)/A
# Almacenar resultados de salida
if ( t - t_ultimaCom + h/2 > t_com | termina ) {
t_plot      <- c(t_plot, t)
hsp_plot    <- c(hsp_plot, hsp)
hr_plot     <- c(hr_plot, hr)
av1_plot    <- c(av1_plot, av1)
av2_plot    <- c(av2_plot, av2)
e_plot      <- c(e_plot, e)
u_plot      <- c(u_plot, u)
Fin_plot    <- c(Fin_plot, Fin)
Fout1_plot  <- c(Fout1_plot, Fout1)
Fout2_plot  <- c(Fout2_plot, Fout2)

t_ultimaCom <- t
}
# Valor en t+h de los estados
hr <- hr + h*derh
I  <- I + h*derI
# Actualización del valor del tiempo
t  <- t + h
}
# Representación gráfica
# Para poder usar minor.tick es necesario instalar el paquete Hmisc
# Configuración de la representación gráfica
par( mfrow = c(2,1) )
# hsp vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, hsp_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "hsp [m]", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Altura de referencia", cex = 1)
# hr vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, hr_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "hr [m]", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Altura real", cex = 1)

dev.new()
par( mfrow = c(2,1) )

# Fin vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, Fin_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "Fin [kg/s]", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Flujo de entrada", cex = 1)

dev.new()
par( mfrow = c(2,1) )
# Fout1 vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, Fout1_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "Fout1 [kg/s]", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Flujo de salida 1", cex = 1)

# Fout2 vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, Fout2_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "Fout2 [kg/s]", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Flujo de salida 2", cex = 1)

dev.new()
par( mfrow = c(2,1) )
# av1 vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, av1_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "av1", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Estado  de la valvula 1", cex = 1)

# av2 vs t
par( mai = c(0.4,1,0.8,0.2), cex = 1.2 )
plot(t_plot, av2_plot, lty = 1, type = "l",
xlim = c(0,t_fin), ylim = c(0,5),
yaxt = "n", xlab = "", ylab = "av2", lwd = 2 )
axis(2, las = 2)
minor.tick(nx = 2, ny = 5, tick.ratio = 0.5)
abline(v = seq(0,t_fin,10*t_com), h = seq(0,5,0.2),
lwd = 0.5, lty = 3)
abline(h = 0, lwd = 1, lty = 1)
title("Estado  de la valvula 2", cex = 1)
