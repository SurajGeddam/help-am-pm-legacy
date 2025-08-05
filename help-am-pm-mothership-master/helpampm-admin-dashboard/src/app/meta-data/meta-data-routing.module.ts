import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HelpComponent } from './help/help.component';
import { TaxComponent } from './tax/tax.component';
import { CountryComponent } from './country/country.component';
import { CategoryComponent } from './category/category.component';
import { FaqComponent } from './faq/faq.component';
import { StaticContentComponent } from './static-content/static-content.component';
import { CategoryDetailComponent } from './category/category-detail/category-detail.component';
import { InsuranceTypeComponent } from './insurance-type/insurance-type.component';
import { LicenseTypeComponent } from './license-type/license-type.component';
import { CommissionComponent } from './commission/commission.component';

const routes: Routes = [

    {
        path: 'category',
        component: CategoryComponent
    },
    {
        path: 'category-details/:id',
        component: CategoryDetailComponent
    },
    {
        path: 'help',
        component: HelpComponent
    },
    {
        path: 'commission',
        component: CommissionComponent
    },
    {
        path: 'tax',
        component: TaxComponent
    },
    {
            path: 'country',
            component: CountryComponent
        },
    {
        path: 'insurance-type',
        component: InsuranceTypeComponent
    },
    {
        path: 'license-type',
        component: LicenseTypeComponent
    },
    {
        path: 'faq',
        component: FaqComponent
    },
    {
        path: 'static-content',
        component: StaticContentComponent
    },

];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class MetaDataRoutingModule { }
