/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { AlimentosComponent } from './alimentos.component';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from 'src/app/app-routing.module';
import { RecetaService } from 'src/app/services/receta.service';
import { RoutingService } from 'src/app/services/routing.service';
import { StubRecetaService } from 'src/app/services/stub-receta.service';
import { StubUsuarioService } from 'src/app/services/stub-usuario.service';
import { HeaderComponent } from '../header/header.component';
import { UsuarioService } from 'src/app/services/usuario.service';
import { PerfilComponent } from '../perfil/perfil.component';

describe('AlimentosComponent', () => {
  let component: AlimentosComponent;
  let fixture: ComponentFixture<AlimentosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AlimentosComponent, HeaderComponent, PerfilComponent],
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
    TestBed.overrideComponent(AlimentosComponent, {
      set: {
        providers: [
          { provide: RecetaService, useClass: StubRecetaService },
          { provide: UsuarioService, useClass: StubUsuarioService }
        ]
      }
    })
    fixture = TestBed.createComponent(AlimentosComponent);
    fixture.detectChanges();
    await fixture.whenStable()
    fixture.detectChanges();
    component = fixture.componentInstance;
  })

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

