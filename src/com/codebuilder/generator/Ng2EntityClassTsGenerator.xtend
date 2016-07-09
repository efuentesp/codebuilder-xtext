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

class Ng2EntityClassTsGenerator {

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (entity : model.entities) {			
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/" + entity.name.toFirstLower + ".class.ts",
					entity.createNg2EntityClassTs
				)
			}
		}
	}

	def CharSequence createNg2EntityClassTs(Entity entity) '''
		import { I«entity.name.toFirstUpper» } from './«entity.name.toFirstLower».interface';
		
		export class «entity.name.toFirstUpper» implements I«entity.name.toFirstUpper» {
			«FOR entity_field : entity.entity_fields»
				«entity_field.createInterfaceField»
			«ENDFOR»
		}	
	'''
	
	def dispatch CharSequence createInterfaceField(EntityTextField f) '''
		«f.name»: string;
	'''

	def dispatch CharSequence createInterfaceField(EntityLongTextField f) '''
		«f.name»: string;
	'''

	def dispatch CharSequence createInterfaceField(EntityIntegerField f) '''
		«f.name»: number;
	'''

	def dispatch CharSequence createInterfaceField(EntityListField f) '''
		«f.name»: string;
	'''

	def dispatch CharSequence createInterfaceField(EntityOptionField f) '''
		«f.name»: string;
	'''

	def dispatch CharSequence createInterfaceField(EntityCheckboxField f) '''
		«f.name»: string;
	'''

	def dispatch CharSequence createInterfaceField(EntityReferenceField f) '''
	'''

	def dispatch CharSequence createInterfaceField(EntityFieldPanelGroup g) '''
		«FOR entity_field : g.entity_fields»
			«entity_field.createInterfaceField»
		«ENDFOR»	
	'''


}