import { Component } from '@angular/core';
import { RoutingService } from './services/routing.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'foodoverflow-angular';

  constructor(private routingService: RoutingService){}
}
