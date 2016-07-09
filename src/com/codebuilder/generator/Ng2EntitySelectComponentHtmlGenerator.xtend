package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.EntitySelect

class Ng2EntitySelectComponentHtmlGenerator {

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (view : model.entity_select) {
				fsa.generateFile(
					"app/" + view.name.toFirstLower + "/" + view.name.toFirstLower + ".component.html",
					view.createNg2ViewComponentHtml
				)				
			}
		}
	}

	def CharSequence createNg2ViewComponentHtml(EntitySelect view) '''
		<div class="input-group"> <!-- input-group -->
			<input	type="text"
					id="«view.name»"
					class="form-control"
					placeholder="«view.base_entity.entity_title.entity_title»"
					value="{{modalSelected.«view.selected_field»}}">
			<span class="input-group-btn">
				<button class="btn btn-default" (click)="onOpenDialog($event)"><i class="fa fa-search"></i></button>
			</span>
		</div> <!-- input-group -->
		
		<!-- Component (View): «view.name» -->
		<modal [animation]="animationEnabled" [backdrop]="'static'" (onClose)="onClose()" #modal>
			
			<modal-header [show-close]="true"> <!-- modal-header -->
				<h4 class="modal-title">Search Fideicomisos</h4>
			</modal-header> <!-- modal-header -->
			
			<modal-body> <!-- modal-body -->
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
									</li>
								</ul>
								<div class="clearfix"></div>
							</div> <!-- x_title -->
							<div class="x_content"> <!-- x_content -->
								<br />
								<table class="table table-striped" *ngIf='«view.name.toFirstLower» && «view.name.toFirstLower».length'> <!-- table -->
									<thead>
										<tr>
											<th></th>
											«FOR f : view.fields»
												<th>«f.label»</th>
											«ENDFOR»
										</tr>
									</thead>
									<tbody>
										<tr *ngFor="let item of «view.name.toFirstLower»">
											<td>
												<input	type="radio"
														class="flat"
														(click)="onSelection(item)"
														name="selected_item"
														id="selected_item_">
											</td>
											«FOR f : view.fields»
												<td>{{item.«f.name.toFirstLower»}}</td>
											«ENDFOR»
										</tr>
									</tbody>
								</table> <!-- table -->
							</div> <!-- panel-x_content -->
						</div> <!-- x_panel -->
					</div> <!-- col-md-12 -->
				</div> <!-- row -->
			</modal-body> <!-- modal-body -->
			
			<modal-footer> <!-- modal-footer -->
				<button type="button" class="btn btn-default" data-dismiss="modal" (click)="modal.dismiss()"><i class="fa fa-close"></i> Cancel</button>
				<button type="button" class="btn btn-primary" (click)="modal.close()"><i class="fa fa-check"></i> Select</button>
			</modal-footer> <!-- modal-footer -->
			
		</modal>				
	'''

}