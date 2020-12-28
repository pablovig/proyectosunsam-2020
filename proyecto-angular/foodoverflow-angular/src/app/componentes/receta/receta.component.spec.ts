import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { ActivatedRoute } from '@angular/router';
import { AppRoutingModule } from 'src/app/app-routing.module';
import { RecetaService } from 'src/app/services/receta.service';
import { RoutingService } from 'src/app/services/routing.service';
import { StubRecetaService } from 'src/app/services/stub-receta.service';
import { StubUsuarioService } from 'src/app/services/stub-usuario.service';
import { UsuarioService } from 'src/app/services/usuario.service';
import { HeaderComponent } from '../header/header.component';
import { RecetaComponent } from './receta.component';


describe('RecetaComponent', () => {
  let component: RecetaComponent;
  let fixture: ComponentFixture<RecetaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RecetaComponent, HeaderComponent],
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

    TestBed.overrideComponent(RecetaComponent, {
      set: {
        providers: [
          {
            provide: ActivatedRoute,
            useValue: {
              snapshot: {
                params: { 'id': 1 },
              }
            }
          },
          { provide: RecetaService, useClass: StubRecetaService },
          { provide: UsuarioService, useClass: StubUsuarioService }
        ]
      }
    })
  fixture = TestBed.createComponent(RecetaComponent)
  component = fixture.componentInstance
  await component.observableRouting()
})


it('should create', () => {
  fixture.detectChanges()
  expect(component).toBeTruthy()
})

it('Nombre de la receta mostrada coincide con Milanesa de pollo', () => {
  const resultHtml = fixture.debugElement.nativeElement
  fixture.detectChanges()
  return fixture.whenStable().then(() => {
    expect(resultHtml.querySelector('[data-testid="tituloReceta"]').value).toBe("Milanesa de pollo")
  })
  
})

it('Calorias mostradas son las que asignamos a la receta en Stub, 4000', () => {
  const resultHtml = fixture.debugElement.nativeElement
  fixture.detectChanges()
  return fixture.whenStable().then(() => {
    expect(resultHtml.querySelector('[data-testid="caloriasTest"]').value).toBe("4000")
  })
})

it('Modificamos calorias y guardamos, cambia calorias a 1000', () => {
  const resultHtml = fixture.debugElement.nativeElement
  fixture.detectChanges()
  component.receta.calorias = 1000
  resultHtml.querySelector('[data-testid="guardado"]').click()
  fixture.detectChanges()

  return fixture.whenStable().then(() => {
    expect(resultHtml.querySelector('[data-testid="caloriasTest"]').value).toBe("1000")
  })
})

it('El componente visualiza el nombre del autor de la Receta que creamos en Stub, German', () => {
  const resultHtml = fixture.debugElement.nativeElement
  fixture.detectChanges()
  return fixture.whenStable().then(() => {
    expect(resultHtml.querySelector('[data-testid="nombreAutor"]').textContent).toBe("por German")
  })
})


it('Compara cantidad de filas de colaboradores con 2', async () => {
  fixture.detectChanges()
  const resultHtml = fixture.debugElement.nativeElement
  expect(resultHtml.querySelectorAll('[data-testid="fila-colaboradores"]').length).toBe(2)
})

it('Compara cantidad de filas de pasos con 1', async () => {
  fixture.detectChanges()
  const resultHtml = fixture.debugElement.nativeElement
  expect(resultHtml.querySelectorAll('[data-testid="fila-pasos"]').length).toBe(1)
})

it('Compara cantidad de filas de ingredientes con 2', async () => {
  fixture.detectChanges()
  const resultHtml = fixture.debugElement.nativeElement
  expect(resultHtml.querySelectorAll('[data-testid="fila-ingredientes"]').length).toBe(2)
})

})