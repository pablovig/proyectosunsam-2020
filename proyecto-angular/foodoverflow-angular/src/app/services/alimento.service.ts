import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Alimento } from 'src/domain/alimento';
import { GrupoAlimenticio } from 'src/domain/grupoAlimenticio'
import { REST_SERVER_URL } from './configuracion';

@Injectable({
  providedIn: 'root'
})
export class AlimentoService {

  public alimentos:Alimento[] = []

  constructor(private http: HttpClient) {
    // this.alimentos=[
    //   new Alimento('Lentejas',GrupoAlimenticio.CEREALES_LEGUMBRES_DERIVADOS),
    //   new Alimento('Cebolla',GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS),
    //   new Alimento('Sal',GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS),
    //   new Alimento('Pimienta',GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS),
    //   new Alimento('Morron',GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS),
    //   new Alimento('Papa',GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS),
    // ]
   }

  //  getAlimento():Alimento[] {
  //    return this.alimentos
  //  }

  //muestro alimentos como promesa
   async getAlimentos(): Promise<Alimento[]> {
     //lamado al back
    const alimentos = await this.http.get<Alimento[]>(REST_SERVER_URL + '/alimento').toPromise()
    //para cada alimento los convierte
    return alimentos.map((alimento) => Alimento.fromJson(alimento))
  }
}
