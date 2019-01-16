---
title: "R Notebook"
output:
  html_notebook: default
  pdf_document: default
---
```{r}
s=seq(0.5,2,by=0.01)
n=2*((qnorm(0.85)+qnorm(0.975))*s/0.2)^2
plot(s,n,type='l',ylab="sample size",xlab="standard deviation",main="sample size vs standard deviation")

```


```{r}
c1=0.25
c2=0.50
c=0.25
((qnorm(0.975)*sqrt(2*c1*(1-c1))+qnorm(0.9)*sqrt(c1*(1-c1)+c2*(1-c2)))/c)^2
```

```{r}
r=3
((qnorm(0.975)*sqrt(2*c1*(1-c1)*(1/r+1))+qnorm(0.9)*sqrt(c1*(1-c1)/r+c2*(1-c2)))/c)^2
```

```{r}
s=function(lamda)
{
  size=(((qnorm(0.975)+qnorm(0.85))/0.2)^2)*1*(1+1/lamda)*(1+lamda)
  return(size)
}
lambda=seq(0.1, 5,0.01)
optimise(s,c(0,5))

```

```{r}
size=function(lambda){
z1=qnorm(1-0.05/2)
z2=qnorm(1-0.1)
theta1=0.25
theta2=0.5
sigma0=sqrt(theta1*(1-theta1)*(1/lambda+1))
sigma1=sqrt(theta1*(1-theta1)/lambda+theta2*(1-theta2))
delta=theta2-theta1
s=(z1*sigma0+z2*sigma1)^2/delta^2
s}
lambda=seq(0.1, 5,0.01)
N=0
for(i in 1: length(lambda) ){N[i]=size(lambda[i])+lambda[i]*size(lambda[i])}
plot(lambda, N, type="l")

```
We plot the curve and find out the optimal allocation ratio that yields the smallest (total) number of patients. The optimal allocation rate is around 0.95.
