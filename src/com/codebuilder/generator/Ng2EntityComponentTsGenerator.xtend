package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2

import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.Entity
import com.codebuilder.codeBuilder.EntityTextField
import com.codebuilder.codeBuilder.EntityLongTextField
import com.codebuilder.codeBuilder.EntityIntegerField
import com.codebuilder.codeBuilder.EntityListField
import com.codebuilder.codeBuilder.EntityOptionField
import com.codebuilder.codeBuilder.EntityCheckboxField
import com.codebuilder.codeBuilder.EntityReferenceField
import com.codebuilder.codeBuilder.EntityFieldPanelGroup

class Ng2EntityComponentTsGenerator {
	
	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (entity : model.entities) {			
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/add-" + entity.name.toFirstLower + ".component.ts",
					entity.createEntityComponentTs("add")
				)
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/edit-" + entity.name.toFirstLower + ".component.ts",
					entity.createEntityComponentTs("edit")
				)				
			}
		}
	}

	def CharSequence createEntityComponentTs(Entity entity, String action) '''
		import { Component, OnInit } from '@angular/core';
		import { Router, ROUTER_DIRECTIVES, ROUTER_PROVIDERS, RouteConfig, RouteParams } from '@angular/router-deprecated';
		import { Control, ControlGroup, FormBuilder, Validators, FORM_DIRECTIVES } from '@angular/common';
		
		import { I«entity.name.toFirstUpper» } from './«entity.name.toFirstLower».interface';
		import { «entity.name.toFirstUpper» } from './«entity.name.toFirstLower».class';
		import { «entity.name.toFirstUpper»Service } from './«entity.name.toFirstLower».service';
		
		@Component({
			templateUrl: 'app/«entity.name.toFirstLower»/«action»-«entity.name.toFirstLower».component.html',
			directives: [FORM_DIRECTIVES]
		})
		export class «action.toFirstUpper»«entity.name.toFirstUpper»Component implements OnInit {

			form: ControlGroup;
			
			«FOR f : entity.entity_fields»
				«f.createNg2ComponentControlDefinition»
			«ENDFOR»

			private _id;
			public errorMessage: string;			
			public «entity.name.toFirstLower»;

			constructor(private builder: FormBuilder,
						private router: Router,
						private params: RouteParams,
						private _«entity.name.toFirstLower»Service: «entity.name.toFirstUpper»Service) {
				
				this._id = params.get('id');
			}
			
			doOnSubmit(event) : void {
				«IF action=='add'»
					this._«entity.name.toFirstLower»Service.addItem(this.form.value)
						.subscribe(
							data => console.log(data),
							error => console.log(error)
						);					
				«ENDIF»
				«IF action=='edit'»
					this._«entity.name.toFirstLower»Service.updateItem(this.form.value)
						.subscribe(
							data => console.log(data),
							error => console.log(error)
						);
				«ENDIF»
				//this._router.navigateByUrl('/«entity.name.toFirstLower»');
				event.preventDefault();
			}

			ngOnInit() : void {
				«IF action=='edit'»
					this._«entity.name.toFirstLower»Service.get«entity.name.toFirstUpper»(this._id)
						.subscribe(
							data => {
								this.«entity.name.toFirstLower» = <I«entity.name.toFirstUpper»>data;
								«FOR f : entity.entity_fields»
									«f.createNg2ComponentControlItemUpdate(entity)»
								«ENDFOR»								
							},
							error => this.errorMessage = <any>error
							//() => console.log(this.«entity.name.toFirstLower»)
						);
				«ENDIF»
							
				«FOR f : entity.entity_fields»
					«f.createNg2ComponentControlItem»
				«ENDFOR»
				
				this.form = this.builder.group({
					«FOR f : entity.entity_fields SEPARATOR ','»
						«f.createNg2ComponentControlGroupItem»
					«ENDFOR»
				});
			}
		}
	'''
	
	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityTextField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''

	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityLongTextField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''
	
	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityIntegerField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''

	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityListField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''
	
	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityOptionField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''

	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityCheckboxField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''
	
	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityReferenceField f, Entity e) '''
		this.«f.name».updateValue(this.«e.name.toFirstLower».«f.name»);
	'''

	def dispatch CharSequence createNg2ComponentControlItemUpdate(EntityFieldPanelGroup g, Entity e) '''
		«FOR f : g.entity_fields»
			«f.createNg2ComponentControlItemUpdate(e)»
		«ENDFOR»	
	'''	
	
		

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityTextField f) '''
		«f.name»: Control;
	'''

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityLongTextField f) '''
		«f.name»: Control;
	'''	

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityIntegerField f) '''
		«f.name»: Control;
	'''

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityListField f) '''
		«f.name»: Control;
	'''		

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityOptionField f) '''
		«f.name»: Control;
	'''

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityCheckboxField f) '''
		«f.name»: Control;
	'''	

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityReferenceField f) '''
		«f.name»: Control;
	'''

	def dispatch CharSequence createNg2ComponentControlDefinition(EntityFieldPanelGroup g) '''
		«FOR f : g.entity_fields»
			«f.createNg2ComponentControlDefinition»
		«ENDFOR»
	'''
	
	
		
	def dispatch CharSequence createNg2ComponentControlItem(EntityTextField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
				«f.maxLenghtValidator»
			])
		);
	'''

	def dispatch CharSequence createNg2ComponentControlItem(EntityLongTextField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);
	'''	

	def dispatch CharSequence createNg2ComponentControlItem(EntityIntegerField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);
	'''

	def dispatch CharSequence createNg2ComponentControlItem(EntityListField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);
	'''	

	def dispatch CharSequence createNg2ComponentControlItem(EntityOptionField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);
	'''

	def dispatch CharSequence createNg2ComponentControlItem(EntityCheckboxField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);
	'''	

	def dispatch CharSequence createNg2ComponentControlItem(EntityReferenceField f) '''
		this.«f.name» = new Control(
			'',
			Validators.compose([
				«f.requiredValidator»
			])
		);	
	'''

	def dispatch CharSequence createNg2ComponentControlItem(EntityFieldPanelGroup g) '''
		«FOR f : g.entity_fields»
			«f.createNg2ComponentControlItem»
		«ENDFOR»
	'''	
	
	
		
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityTextField f) '''
		«f.name»: this.«f.name»
	'''
	
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityLongTextField f) '''
		«f.name»: this.«f.name»
	'''

	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityIntegerField f) '''
		«f.name»: this.«f.name»
	'''
	
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityListField f) '''
		«f.name»: this.«f.name»
	'''
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityOptionField f) '''
		«f.name»: this.«f.name»
	'''
	
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityCheckboxField f) '''
		«f.name»: this.«f.name»
	'''
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityReferenceField f) '''
		«f.name»: this.«f.name»
	'''
	
	def dispatch CharSequence createNg2ComponentControlGroupItem(EntityFieldPanelGroup g) '''
		«FOR f : g.entity_fields SEPARATOR ','»
			«f.createNg2ComponentControlGroupItem»
		«ENDFOR»
	'''

	def dispatch CharSequence maxLenghtValidator(EntityTextField f) '''
		«IF f.max_length != null»
			Validators.maxLength(«f.max_length.value»),
		«ENDIF»		
	'''

	def dispatch CharSequence maxLenghtValidator(EntityLongTextField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityIntegerField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityListField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityOptionField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityCheckboxField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityReferenceField f) '''
	'''
	
	def dispatch CharSequence maxLenghtValidator(EntityFieldPanelGroup g) '''
		«FOR f : g.entity_fields»
			«f.maxLenghtValidator»
		«ENDFOR»	
	'''
	
	
	
	def dispatch CharSequence requiredValidator(EntityTextField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''

	def dispatch CharSequence requiredValidator(EntityLongTextField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''
	
	def dispatch CharSequence requiredValidator(EntityIntegerField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''

	def dispatch CharSequence requiredValidator(EntityListField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''
	
	def dispatch CharSequence requiredValidator(EntityOptionField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''

	def dispatch CharSequence requiredValidator(EntityCheckboxField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»	
	'''
	
	def dispatch CharSequence requiredValidator(EntityReferenceField f) '''
		«IF f.required != null»
			Validators.required,
		«ENDIF»		
	'''
	
	def dispatch CharSequence requiredValidator(EntityFieldPanelGroup g) '''
		«FOR f : g.entity_fields»
			«f.requiredValidator»
		«ENDFOR»	
	'''
}