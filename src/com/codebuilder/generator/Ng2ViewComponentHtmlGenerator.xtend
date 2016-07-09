package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.View

class Ng2ViewComponentHtmlGenerator {

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (view : model.views) {
				fsa.generateFile(
					"app/" + view.name.toFirstLower + "/" + view.name.toFirstLower + ".component.html",
					view.createNg2ViewComponentHtml
				)				
			}
		}
	}

	def CharSequence createNg2ViewComponentHtml(View view) '''
		<!-- Component (View): «view.name» -->
		<div class="">
			<div class="page-title"> <!-- page title -->
				<div class="title_left"> <!-- title-left -->
					<h3>
						«view.name.toFirstUpper» List
					</h3>
				</div> <!-- title-left -->
				<div class="title_right"> <!-- title-right -->
				</div> <!-- title-right -->
			</div> <!-- page title -->
		
			<div class="clearfix"></div>
		
			«IF view.exposed_filter.size > 0»
				<div class="row"> <!-- row -->
					<div class="col-md-12"> <!-- col-md-12 -->				
						<div class="x_panel"> <!-- x_panel -->
							<div class="x_title"> <!-- x_title -->
								<h2>Search Criteria</h2>
								<div class="clearfix"></div>
							</div> <!-- x_title -->						
							<div class="x_content"> <!-- x_content -->
								<br />
								<form class="form-horizontal">
									«FOR f : view.exposed_filter»
										<div class="form-group">
											<label for="«f.name»" class="col-md-2 control-label">«f.label»</label>
											<div class="col-md-10">
												<input type="text" id="«f.name»" class="form-control">				
											</div>
										</div>
									«ENDFOR»
									<div class="ln_solid"></div>
									<div class="form-group"> <!-- form-group -->
										<div class="col-md-6 col-sm-6 col-xs-6 col-md-offset-2"> <!-- col-md-6 col-sm-6 col-xs-6 -->
											<button type="submit" class="btn btn-default"><i class="fa fa-eraser"></i> Clear</button>
											<button type="submit" class="btn btn-info"><i class="fa fa-search"></i> Search</button>										
										</div> <!-- col-md-6 col-sm-6 col-xs-6 -->
									</div> <!-- form-group -->
								</form>
							</div> <!-- x_content -->
						</div> <!-- x_panel -->
					</div> <!-- col-md-12 -->
				</div> <!-- row -->
			«ENDIF»
			<div class="row"> <!-- row -->
				<div class="col-md-12"> <!-- col-md-12 -->
					<div class="x_panel"> <!-- x_panel -->
						<div class="x_title"> <!-- x_title -->
							<h2>Search Results</h2>
							<ul class="nav navbar-right panel_toolbox">
								<li>
									«IF view.add_link != null»
										<a	[routerLink]="['Add«view.base_entity.name.toFirstUpper»']"
											class="btn btn-primary btn-create"><i class="fa fa-plus"></i> New</a>
									«ENDIF»									
								</li>
							</ul>
							<div class="clearfix"></div>
						</div> <!-- x_title -->					
						<div class="x_content"> <!-- x_content -->
							<br />
							<table class="table table-striped" *ngIf='«view.name.toFirstLower» && «view.name.toFirstLower».length'> <!-- table -->
								<thead>
									<tr>
										«FOR f : view.fields»
											<th>«f.label»</th>
										«ENDFOR»
										«IF view.show_link != null || view.edit_link != null || view.delete_link != null»
											<th>Actions</th>
										«ENDIF»
									</tr>
								</thead>
								<tbody>
									<tr *ngFor="let item of «view.name.toFirstLower»">
										«FOR f : view.fields»
											<td>{{item.«f.name.toFirstLower»}}</td>
										«ENDFOR»
										«IF view.show_link != null || view.edit_link != null || view.delete_link  != null»
											<td>
												«IF view.show_link != null»
													<button type="submit" class="btn btn-sm btn-default"><i class="fa fa-eye"></i> Show</button>
												«ENDIF»
												«IF view.edit_link != null»
													<a [routerLink]="['Edit«view.base_entity.name.toFirstUpper»', {id: item.«view.base_entity.entity_db_table.id_db_table»}]" class="btn btn-sm btn-success"><i class="fa fa-pencil"></i> Edit</a>
												«ENDIF»
												«IF view.delete_link != null»
													<button type="submit" class="btn btn-sm btn-danger"><i class="fa fa-trash-o"></i> Delete</button>
												«ENDIF»
											</td>
										«ENDIF»
									</tr>
								</tbody>
							</table> <!-- table -->
						</div> <!-- x_content -->
					</div> <!-- x_panel -->
				</div> <!-- col-md-12 -->
			</div> <!-- row -->
		<div class="">
	'''

}