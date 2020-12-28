import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HeaderComponent } from './componentes/header/header.component';
import { FormsModule } from '@angular/forms';
import { FooterComponent } from './componentes/footer/footer.component';
import { BusquedaComponent } from './componentes/busqueda/busqueda.component';
import { ResultadosComponent } from './componentes/resultados/resultados.component';
import { CardrecetaComponent } from './componentes/cardreceta/cardreceta.component';
import { PerfilComponent } from './componentes/perfil/perfil.component';
import { AlimentosComponent } from './componentes/alimentos/alimentos.component';
import { RecetaComponent } from './componentes/receta/receta.component';
import { LoginComponent } from './componentes/login/login.component';
import { IngredientesComponent } from './componentes/ingredientes/ingredientes.component';
import { TablaAlimentosComponent } from './componentes/tabla-alimentos/tabla-alimentos.component';
import { AlimentosperfilComponent } from './componentes/alimentosperfil/alimentosperfil.component';
import { ColaboradorComponent } from './componentes/colaborador/colaborador.component';
import { RoutingService } from './services/routing.service';
import { PasosComponent } from './componentes/pasos/pasos.component';
import { HttpClientModule } from '@angular/common/http'



@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    BusquedaComponent,
    ResultadosComponent,
    CardrecetaComponent,
    PerfilComponent,
    AlimentosComponent,
    IngredientesComponent,
    TablaAlimentosComponent,
    RecetaComponent,
    LoginComponent,
    AlimentosperfilComponent,
    ColaboradorComponent,
    AlimentosperfilComponent,
    PasosComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    AppRoutingModule
  ],
  providers: [
    RoutingService
    
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
