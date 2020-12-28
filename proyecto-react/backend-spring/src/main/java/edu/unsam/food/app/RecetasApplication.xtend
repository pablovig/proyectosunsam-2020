package edu.unsam.food.app
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.context.annotation.ComponentScan

@SpringBootApplication 
@ComponentScan(basePackages=#["edu.unsam.food"])
class RecetasApplication {
	def static void main(String[] args) {
		new BootstrapReact => [run]
		SpringApplication.run(RecetasApplication, args)
	}
}
