import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule } from '@angular/forms';
import { BrowserModule, By } from '@angular/platform-browser';
import { AppRoutingModule } from 'src/app/app-routing.module';
import { RecetaService } from 'src/app/services/receta.service';
import { RoutingService } from 'src/app/services/routing.service';
import { StubRecetaService } from 'src/app/services/stub-receta.service';
import { StubUsuarioService } from 'src/app/services/stub-usuario.service';
import { UsuarioService } from 'src/app/services/usuario.service';
import { CardrecetaComponent } from '../cardreceta/cardreceta.component';
import { HeaderComponent } from '../header/header.component';
import { ResultadosComponent } from '../resultados/resultados.component';
import { BusquedaComponent } from './busqueda.component';


describe('BusquedaComponent', () => {
  let component: BusquedaComponent;
  let fixture: ComponentFixture<BusquedaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BusquedaComponent, ResultadosComponent, CardrecetaComponent, HeaderComponent ],
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
    TestBed.overrideComponent(BusquedaComponent, {
      set: {
        providers: [
          { provide: RecetaService, useClass: StubRecetaService },
          { provide: UsuarioService, useClass: StubUsuarioService }
        ]
      }
    })
    fixture = TestBed.createComponent(BusquedaComponent);
    fixture.detectChanges();
    await fixture.whenStable()
    fixture.detectChanges();
    component = fixture.componentInstance;
  })

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('El componente trae del Stub 4 recetas', async () => {
    expect(component.recetas.length).toBe(4)
  })

  it('Se borra una receta y quedan tres', async () => {
    const resultHtml = fixture.debugElement.nativeElement
    fixture.detectChanges()
    resultHtml.querySelector('[data-testid="eliminar_1"]').click()
    fixture.detectChanges()

    return fixture.whenStable().then(() => {
      expect(getAllByTestId(fixture, 'filarecetas').length).toBe(3) // Se obtienen 2..
    })
  })

  it('Se generan 4 filas correspondiente a las recetas del Stub', async () => {
    const resultHtml = fixture.debugElement.nativeElement
    resultHtml.querySelector('[data-testid="buscador"]').click()
    fixture.detectChanges()
    expect(resultHtml.querySelectorAll('[data-testid="filarecetas"]').length).toBe(4)
  })

  it('Se busca palabra Milanesa y se obtienen dos', async () => {
    component.recetaBuscada= "Milanesa"
    fixture.detectChanges()
    const resultHtml = fixture.debugElement.nativeElement
    resultHtml.querySelector('[data-testid="buscador"]').click()
    fixture.detectChanges()

    return fixture.whenStable().then(() => {
      expect(getAllByTestId(fixture, 'filarecetas').length).toBe(2) // Se obtienen 4..
    })
  })

  

});

export const getAllByTestId = (appComponent: any, testId: string) => {
  const compiled = appComponent.debugElement.nativeElement
  return compiled.querySelectorAll(`[data-testid="${testId}"]`)
}
