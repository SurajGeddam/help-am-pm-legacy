import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HistoryOrdersComponent } from './history-orders/history-orders.component';
import { RunningOrdersComponent } from './running-orders/running-orders.component';
import { ScheduledOrdersComponent } from './scheduled-orders/scheduled-orders.component';

const routes: Routes = [
   
    {
        path: 'running',
        component: RunningOrdersComponent
    },
    {
        path: 'scheduled',
        component: ScheduledOrdersComponent
    },
    {
        path: 'history',
        component: HistoryOrdersComponent
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class OrderRoutingModule { }
