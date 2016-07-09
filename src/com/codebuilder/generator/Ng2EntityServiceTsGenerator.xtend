package com.codebuilder.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.codebuilder.codeBuilder.Model
import com.codebuilder.codeBuilder.Entity

class Ng2EntityServiceTsGenerator {
	
	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
 		for (model : (resource.contents.filter(typeof(Model)))) {
			for (entity : model.entities) {			
				fsa.generateFile(
					"app/" + entity.name.toFirstLower + "/" + entity.name.toFirstLower + ".service.ts",
					entity.createNg2EntityServiceTs
				)
			}
		}
	}
	
	def CharSequence createNg2EntityServiceTs(Entity entity) '''
		import { Injectable } from '@angular/core';
		import { Http, Response, Headers, RequestOptions } from '@angular/http';
		import { Observable } from 'rxjs/Observable';
		
		import { I«entity.name.toFirstUpper» } from './«entity.name.toFirstLower».interface';

		@Injectable()
		export class «entity.name.toFirstUpper»Service {
			
			private _«entity.name.toFirstLower»Url;
			
			response: I«entity.name.toFirstUpper»;
			
			constructor(private _http: Http) {
				this._«entity.name.toFirstLower»Url = 'http://localhost:3001/«entity.name.toFirstLower»';
			}
			
			getAll«entity.name.toFirstUpper»() : Observable<I«entity.name.toFirstUpper»[]> {
				return this._http.get(this._«entity.name.toFirstLower»Url)
					.map((response: Response) => <I«entity.name.toFirstUpper»[]>response.json())
					//.do(data => console.log('All: ' + JSON.stringify(data)))
					.catch(this.handleError);
			}

			get«entity.name.toFirstUpper»(id: number): Observable<I«entity.name.toFirstUpper»> {
				return this._http.get(this._«entity.name.toFirstLower»Url + '/' + id)
					.map((response: Response) => <I«entity.name.toFirstUpper»>response.json())
					//.do(data => console.log('All: ' + JSON.stringify(data)))
					.catch(this.handleError);									
			}

			addItem(item) : Observable<I«entity.name.toFirstUpper»[]> {
				let body = JSON.stringify(item);
				let headers = new Headers({ 'Content-Type': 'application/json' });
				let options = new RequestOptions({ headers: headers });
				
				console.log("http put: " + body);
				
				return this._http.post(this._«entity.name.toFirstLower»Url, body, options)
					.map(this.extractData)
					.catch(this.handleError);
			}

			updateItem(item) : Observable<I«entity.name.toFirstUpper»[]> {
				let body = JSON.stringify(item);
				let headers = new Headers({ 'Content-Type': 'application/json' });
				let options = new RequestOptions({ headers: headers });
				
				console.log("http put: " + body);
				
				return this._http.put(this._«entity.name.toFirstLower»Url + '/' + item.«entity.entity_db_table.id_db_table», body, options)
					.map(this.extractData)
					.catch(this.handleError);
			}

		private extractData(res: Response) {
			let body = res.json();
			return body.data || {};
		}

			private handleError(error: Response) {
				console.error(error);
				return Observable.throw(error.json().error || 'Server error');
			}
		}
	'''
	
	
}