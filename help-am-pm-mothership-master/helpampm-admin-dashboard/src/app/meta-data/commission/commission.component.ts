import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { FilterService } from 'src/app/core/service/filter.service';
import { MessageService } from 'src/app/core/service/message.service';
import { MetaDataService } from '../meta-data.service';

@Component({
  selector: 'app-commission',
  templateUrl: './commission.component.html',
  styleUrls: ['./commission.component.sass']
})
export class CommissionComponent implements OnInit {
    @ViewChild(DatatableComponent, { static: false }) table: DatatableComponent;

      commissionData = [];
      data = [];
      commissionFilteredData = [];
      commissionForm: FormGroup;
      isEdit: boolean = false;
      isSubmitted: boolean = false;

      constructor(
        private fb: FormBuilder,
        private modalService: NgbModal,
        private metaDataService: MetaDataService,
        private messageService: MessageService,
        private filterService: FilterService
      ) {
      }

      createCommissionForm(p) {
        this.commissionForm = this.fb.group({
          id: ['', []],
          county: ['', [Validators.required]],
          rate: ['', Validators.required],
          stripeFixedAmount: ['', Validators.required],
          stripePercentAmount: ['', [Validators.required]],
          isActive: ['', [Validators.required]]
        });
      }

      ngOnInit() {
      this.getData();
      }

      /**
      *@method getData
      *@description gets commission value data from the metaDataService
      **/
      getData() {
          this.metaDataService.getCommission().subscribe(
              (res:any) => {
                this.commissionData = res;
                this.commissionFilteredData = this.commissionData;
              });
      }

      /**
       * @method edit
       * @param commissionInfo
       * @param content
       * @param isEdit
       * @description open's the modal for the Edit and add Commission info
       */
      editCommissionData(commissionInfo, content, isEdit) {
        this.createCommissionForm(commissionInfo);
        this.commissionForm.reset();
        this.isEdit = isEdit;
        let ngbModalOptions: NgbModalOptions = {
          backdrop: 'static',
          keyboard: false,
          ariaLabelledBy: 'modal-basic-title'
        };
        this.modalService.open(content, ngbModalOptions);
        if (isEdit) {
          this.commissionForm.setValue({
            id: commissionInfo.id,
            county: commissionInfo.county,
                   rate: commissionInfo.rate,
                   stripeFixedAmount: commissionInfo.stripeFixedAmount,
                   stripePercentAmount: commissionInfo.stripePercentAmount,
                   isActive:commissionInfo.isActive
          });
        }
      }

      /**
       * @method onEditSave
       * @param form
       * @description Save's the edit end add Commission Info Form
       */
      onEditSave(form: FormGroup) {
        this.isSubmitted = true;

          if (form.valid && this.isEdit) {
             // Edit Form Submit
             this.metaDataService.updateCommission(form.value).subscribe((res: any) => {
               this.updateObjectInList(res);
               this.commissionForm.reset();
               this.modalService.dismissAll();
               this.messageService.showSuccess("Record Edited Successfully");
             }
             )
           } else if (form.valid && !this.isEdit) {
             // Add form Submit
             this.metaDataService.createCommission(form.value).subscribe(
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
       * @description add the updated object on the top of the list of Help
       */
      updateObjectInList(object) {
        const data = this.commissionData.filter(ele => ele.id != object.id);
        data.unshift(object);
        this.commissionData = [...data];
      }

      /**
       * @method filterDatatable
       * @param event
       * @description search for the filter data table
       */
      filterDatatable(event) {
        this.commissionData = this.filterService.filter(event, this.commissionFilteredData, this.commissionData);
        this.table.offset = 0;
      }

      changeStatus(event, row) {
        let commission = row;
        commission = {
          id: row.id,
          isActive: event.checked
        }
    
        this.metaDataService.updateCommission(commission).subscribe((res: any) => {
          var data: any;
          data = res;
          if (data.isActive) {
            this.messageService.showSuccess("Commission " + data.county + " Enabled successfully")
          } else {
            this.messageService.showSuccess("Commission " + data.county + "  Disabled successfully")
          }
    
        });
      }
}
