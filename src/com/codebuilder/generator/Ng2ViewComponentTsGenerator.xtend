package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2

import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.View

class Ng2ViewComponentTsGenerator {

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (view : model.views) {
				fsa.generateFile(
					"app/" + view.name.toFirstLower + "/" + view.name.toFirstLower + ".component.ts",
					view.createNg2ViewComponentTs
				)				
			}
		}
	}

	def CharSequence createNg2ViewComponentTs(View view) '''
		import { Component, OnInit } from '@angular/core';
		import { ROUTER_DIRECTIVES } from '@angular/router-deprecated';
		
		import { I«view.base_entity.name.toFirstUpper» } from '../«view.base_entity.name.toFirstLower»/«view.base_entity.name.toFirstLower».interface';
		import { «view.base_entity.name.toFirstUpper»Service } from '../«view.base_entity.name.toFirstLower»/«view.base_entity.name.toFirstLower».service';
		
		@Component({
			templateUrl: 'app/«view.name.toFirstLower»/«view.name.toFirstLower».component.html',
			directives: [ROUTER_DIRECTIVES]
		})
		export class «view.name.toFirstUpper»Component implements OnInit {
			errorMessage: string;
			«view.name.toFirstLower» : I«view.base_entity.name.toFirstUpper»[];
			
			constructor(private _«view.base_entity.name.toFirstLower»Service: «view.base_entity.name.toFirstUpper»Service) {}
			
			ngOnInit() : void {
				this._«view.base_entity.name.toFirstLower»Service.getAll«view.base_entity.name.toFirstUpper»()
					.subscribe(
						data => this.«view.name.toFirstLower» = data,
						error => this.errorMessage = <any>error);
			}
		}
	'''

}