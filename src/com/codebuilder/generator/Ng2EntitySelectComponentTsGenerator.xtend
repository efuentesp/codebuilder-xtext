package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2

import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.EntitySelect

class Ng2EntitySelectComponentTsGenerator {

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (view : model.entity_select) {
				fsa.generateFile(
					"app/" + view.name.toFirstLower + "/" + view.name.toFirstLower + ".component.ts",
					view.createNg2ViewComponentTs
				)				
			}
		}
	}

	def CharSequence createNg2ViewComponentTs(EntitySelect view) '''
		import { Component, ViewChild, OnInit } from '@angular/core';
		import { ROUTER_DIRECTIVES } from '@angular/router-deprecated';
		
		import { MODAL_DIRECTIVES, ModalComponent } from 'ng2-bs3-modal/ng2-bs3-modal';
		
		import { I«view.base_entity.name.toFirstUpper» } from '../«view.base_entity.name.toFirstLower»/«view.base_entity.name.toFirstLower».interface';
		import { «view.base_entity.name.toFirstUpper»Service } from '../«view.base_entity.name.toFirstLower»/«view.base_entity.name.toFirstLower».service';
		
		@Component({
			selector: '«view.name»',
			templateUrl: 'app/«view.name.toFirstLower»/«view.name.toFirstLower».component.html',
			directives: [ROUTER_DIRECTIVES, MODAL_DIRECTIVES]
		})
		export class «view.name.toFirstUpper»Component implements OnInit {
			@ViewChild('modal')
			modal: ModalComponent;
			
			errorMessage: string;
			«view.name.toFirstLower» : I«view.base_entity.name.toFirstUpper»[];
			
			modalSelected: any = {};
			selected: any = {};
			
			animationEnabled: boolean = true;
			
			constructor(private _«view.base_entity.name.toFirstLower»Service: «view.base_entity.name.toFirstUpper»Service) {}
			
			ngOnInit() : void {
				this._«view.base_entity.name.toFirstLower»Service.getAll«view.base_entity.name.toFirstUpper»()
					.subscribe(
						data => this.«view.name.toFirstLower» = data,
						error => this.errorMessage = <any>error);
			}
			
			onClose() {
				this.modalSelected = this.selected;
			}
			
			onOpenDialog(event) {
				this.modal.open('lg');
				event.preventDefault();
			}
			
			onSelection(item) {
				this.selected = item;
			}
		}
	'''

}