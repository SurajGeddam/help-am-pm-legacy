import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { MessageService } from 'src/app/core/service/message.service';
import { StorageService } from 'src/app/core/service/storage.service';
import { FilterService } from '../../core/service/filter.service';
import { MetaDataService } from '../meta-data.service';


@Component({
  selector: 'app-category',
  templateUrl: './category.component.html',
  styleUrls: ['./category.component.sass']
})
export class CategoryComponent implements OnInit {
  @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

  rows = [];
  data = [];
  filteredData = [];
  editForm: FormGroup;
  isEdit: boolean = false;

  categoryId: number;

  constructor(
    private fb: FormBuilder,
    private modalService: NgbModal,
    private metaDataService: MetaDataService,
    private messageService: MessageService,
    private filterService: FilterService, 
  ) {
    this.editForm = this.fb.group({
      id: new FormControl(),
      description: ['', [Validators.required, Validators.minLength(3)]],
      name: ['', Validators.required],
      commercialService: ['', Validators.required],
      residentialService: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.getData();
  }

  /**
   * @method getData
   * @Description get's All Category from the metadaService
   */
  getData() {
    this.metaDataService.getAllCategory().subscribe(
      (res: any) => {
        this.data = res;
        this.filteredData = this.data;
      }
    )
  }

  /**
   * @method edit
   * @param category 
   * @param content 
   * @param isEdit
   * @description open's the modal for the Edit and add Categories
   */

   editCategory(category, content, isEdit) {
    //  this.editForm.reset();
    this.isEdit = isEdit;
    let ngbModalOptions: NgbModalOptions = {
      backdrop: 'static',
      keyboard: false,
      ariaLabelledBy: 'modal-basic-title'
    };
    this.modalService.open(content, ngbModalOptions);
    if (isEdit) {
      this.editForm.setValue({
        id: category.id,
        description: category.description,
        name: category.name,
        residentialService: category.residentialService,
        commercialService: category.commercialService
      });
    }
  }
  opencategory(content: any, data: any) {
    this.categoryId = data.id;
    const modaRef = this.modalService.open(content, {
      ariaLabelledBy: '',
      backdrop: false
    });

  }
  
  /**
   * @method onEditSave
   * @param form 
   * @description Save's the edit end add leadSoruce Form
   */
  onEditSave(form: FormGroup) {
    if (form.valid && this.isEdit) {
      // Edit Form Submit
      this.metaDataService.updateCategory(form.value).subscribe((res: any) => {
        this.updateObjectInList(res);
        this.editForm.reset();
        this.modalService.dismissAll();
        this.messageService.showSuccess("Record Edited Successfully");
      }
      )
    } else if (form.valid && !this.isEdit) {
      // Add form Submit
      this.metaDataService.updateCategory(form.value).subscribe(
        res => {
          form.reset();
          this.modalService.dismissAll();
          this.messageService.showSuccess('Record Added Successfully');
          this.data.unshift(res);
          this.data = [...this.data];
        }
      )
    }
  }

  /**
   * @method updateObjectInList
   * @param object 
   * @description add the updated object on the top of the list of category's
   */
  updateObjectInList(object) {
    const data = this.data.filter(ele => ele.id != object.id);
    data.unshift(object);
    this.data = [...data];
  }

  /**
   * @method filterDatatable
   * @param event 
   * @description search for the filter data table
   */
  filterDatatable(event) {
    this.data = this.filterService.filter(event, this.filteredData, this.data);
    this.table.offset = 0;
  }

  getClassColor(row) {
    if (row) {
      return "fas fa-check-circle"
    } else {
      return " icon-close"
    }
  }
  getIconColor(row) {
    if (row) {
      return "green"
    } else {
      return "red"
    }
  }

  changeStatus(event, row) {
    let category = row;
    category = {
      id: row.id,
      isActive: event.checked
    }


    this.metaDataService.updateCategory(category).subscribe((res: any) => {
      var data: any;
      data = res;
      if (data.isActive) {
        this.messageService.showSuccess("Category " + data.name + " Enabled successfully")
      } else {
        this.messageService.showSuccess("Category " + data.name + "  Disabled successfully")
      }

    });
  }

}

