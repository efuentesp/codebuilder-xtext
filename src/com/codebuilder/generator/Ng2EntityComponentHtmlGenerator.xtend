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

class Ng2EntityComponentHtmlGenerator {
	
	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (entity : model.entities) {			
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/add-" + entity.name.toFirstLower + ".component.html",
					entity.createNg2EntityComponentHtml("add")
				)
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/edit-" + entity.name.toFirstLower + ".component.html",
					entity.createNg2EntityComponentHtml("edit")
				)				
			}
		}

	}

	def CharSequence createNg2EntityComponentHtml(Entity entity, String action) '''
		<!-- Component (Entity): «entity.name» -->
		<div class="">
			<div class="page-title"> <!-- page title -->
				<div class="title_left"> <!-- title-left -->
					<h3>
						«IF action == "add"»Add «ENDIF»
						«IF action == "edit"»Edit «ENDIF»
						«entity.name.toFirstUpper»
					</h3>
				</div> <!-- title-left -->
				<div class="title_right"> <!-- title-right -->
				</div> <!-- title-right -->
			</div> <!-- page title -->
		
			<div class="clearfix"></div>
		
			<div class="row"> <!-- row -->
				<div class="col-md-12"> <!-- col-md-12 -->
					<div class="x_panel"> <!-- x_panel -->
						<div class="x_title"> <!-- x_title -->
							<h2>«entity.entity_title.entity_title»</h2>
							<div class="clearfix"></div>
						</div> <!-- x_title -->
						<div class="x_content"> <!-- x_content -->
							<br />
							<form	[ngFormModel]="form"
									class="form-horizontal form-label-left"
									(submit)="doOnSubmit($event)">
								«FOR entity_field : entity.entity_fields»
									«entity_field.createHtmlFormField»
								«ENDFOR»
								<div class="ln_solid"></div>
								<div class="form-group"> <!-- form-group -->
									<div class="col-md-6 col-sm-6 col-xs-6 col-md-offset-2"> <!-- col-md-6 col-sm-6 col-xs-6 -->
										<button type="submit"
												[disabled]="!form.valid"
												class="btn btn-primary"
												id="«entity.name.toFirstLower»_save"><i class="fa fa-save"></i> Save</button>
									</div> <!-- col-md-6 col-sm-6 col-xs-6 -->
								</div>  <!-- form-group -->
							</form>
						</div> <!-- x_content -->						
					</div> <!-- x_panel -->
				</div> <!-- col-md-12 --> 
			</div> <!-- row -->
		</div>
	'''

	def dispatch CharSequence createHtmlFormField(EntityTextField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				<input	type="text"
						id="«f.name»"
						class="form-control"
						placeholder="«f.label.value»"
						ngControl="«f.name»"
						#«f.name»="ngForm" >
				<div *ngIf="«f.name».dirty && !«f.name».valid && !«f.name».pending">
					«IF f.required != null»
						<div *ngIf="«f.name».errors.required" class="alert alert-danger" role="alert">
							<span class="sr-only">Error:</span>
							'Required field.'
						</div>
					«ENDIF»
					«IF f.max_length != null»
						<div *ngIf="«f.name».errors.maxLength" class="alert alert-danger" role="alert">
							<span class="sr-only">Error:</span>
							'Max Length is «f.max_length.value» characters.'
						</div>
					«ENDIF»
				</div>
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityLongTextField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				<textarea	id="«f.name»"
							class="form-control"
							rows="«IF f.rows != null»«f.rows.value»«ELSE»5«ENDIF»"
							ngControl="«f.name»"
							#«f.name»="ngForm">
				</textarea>
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityIntegerField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				<input	type="number"
						id="«f.name»"
						class="form-control"
						ngControl="«f.name»"
						#«f.name»="ngForm">
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityListField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				<select class="form-control" id="«f.name»">
					<option value="">-- Select one --</option>
					«FOR v : f.values»
						<option value="«v.key»">«v.label»</option>
					«ENDFOR»
				</select>
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityOptionField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name.toFirstLower»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				«FOR v : f.values»
					<div class="radio">
					  <label>
					    <input type="radio" class="flat" name="«f.name.toFirstLower»" id="option_«v.key»" value="«v.key»"> «v.label»</label>
					</div>
				«ENDFOR»
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityCheckboxField f) '''
		
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name.toFirstLower»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
				«FOR v : f.values»
					<div class="checkbox">
					  <label>
					    <input type="checkbox" class="flat" name="«f.name.toFirstLower»" value="«v.key»"> «v.label»</label>
					</div>
				«ENDFOR»
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''
	
	def dispatch CharSequence createHtmlFormField(EntityReferenceField f) '''
	
		<!-- Form Field: «f.name» -->
		<div class="form-group"> <!-- form-group -->
			<label for="«f.name»" class="col-md-2 control-label">
				«IF f.required != null»<span class="required">* </span>«ENDIF»
				«f.label.value»
			</label>
			<div class="col-md-10"> <!-- col-md-10 -->
<!--
				<div class="input-group">
					<input	type="text"
							id="«f.name»"
							class="form-control"
							placeholder="«f.label.value»"
							ngControl="«f.name»"
							#«f.name»="ngForm">
					<span class="input-group-btn">
						<button class="btn btn-info">...</button>
					</span>
				</div>
-->
				<«f.widget.entity_select.name»></«f.widget.entity_select.name»>
				<div *ngIf="«f.name».dirty && !«f.name».valid && !«f.name».pending">
					«IF f.required != null»
						<div *ngIf="«f.name».errors.required" class="alert alert-danger" role="alert">
							<span class="sr-only">Error:</span>
							'Required field.'
						</div>
					«ENDIF»
				</div>
				«IF f.help_text != null»
					<p class="help-block">«f.help_text.value»</p>
				«ENDIF»					
			</div> <!-- col-md-10 -->
		</div> <!-- form-group -->
		'''

	def dispatch CharSequence createHtmlFormField(EntityFieldPanelGroup g) '''
	
		<!-- Panel Group: «g.name» -->
		<div>
			<h4>«g.label.value»</h4>
			<div class="ln_solid"></div>
			<p class="font-gray-dark"></p>
			«FOR entity_field : g.entity_fields»
				«entity_field.createHtmlFormField»
			«ENDFOR»
		</div>
	'''
	
}