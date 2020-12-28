import { ComponentFixture, TestBed } from '@angular/core/testing';
import { CardrecetaComponent } from './cardreceta.component';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from 'src/app/app-routing.module';
import { RecetaService } from 'src/app/services/receta.service';
import { RoutingService } from 'src/app/services/routing.service';
import { StubRecetaService } from 'src/app/services/stub-receta.service';
import { StubUsuarioService } from 'src/app/services/stub-usuario.service';
import { HeaderComponent } from '../header/header.component';
import { UsuarioService } from 'src/app/services/usuario.service';
import { ResultadosComponent } from '../resultados/resultados.component';
import { BusquedaComponent } from '../busqueda/busqueda.component';


describe('CardrecetaComponent', () => {
  let component: CardrecetaComponent;
  let fixture: ComponentFixture<CardrecetaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CardrecetaComponent, HeaderComponent, BusquedaComponent, ResultadosComponent],
      imports: [
        BrowserModule,
        FormsModule,
        AppRoutingModule
      ],
      providers: [
        UsuarioService,
        RecetaService,
        RoutingService
      ]

    })
    .compileComponents()
    TestBed.overrideComponent(CardrecetaComponent, {
      set: {
        providers: [
          { provide: RecetaService, useClass: StubRecetaService },
          { provide: UsuarioService, useClass: StubUsuarioService }
        ]
      }
    })
    fixture = TestBed.createComponent(CardrecetaComponent);
    fixture.detectChanges();
    await fixture.whenStable()
    fixture.detectChanges();
    component = fixture.componentInstance;
  })

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

