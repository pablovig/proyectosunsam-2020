import { Injectable } from '@angular/core';
import { Router, RoutesRecognized } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { filter, pairwise } from 'rxjs/operators';
import { Location } from '@angular/common';

@Injectable({
  providedIn: 'root'
})
export class RoutingService {

  public rutaAnterior = new BehaviorSubject<string>('');
  public rutaAnteriorEstricta = new BehaviorSubject<string>('')

  constructor(private router: Router,private location: Location) {

    this.rutaAnterior.next(this.location.path());



    this.router.events.pipe(
      filter(e => e instanceof RoutesRecognized),
      pairwise(),
        )
    .subscribe((event: any[]) => {
        this.rutaAnterior.next(event[0].urlAfterRedirects);

        if(this.rutaAnterior.value == '/busqueda'){
          this.rutaAnteriorEstricta = Object.assign(new BehaviorSubject<string>(''),this.rutaAnterior)  
        }
        if(this.rutaAnterior.value == '/perfil'){
          this.rutaAnteriorEstricta = Object.assign(new BehaviorSubject<string>(''),this.rutaAnterior)   
        }
    });

  }
}