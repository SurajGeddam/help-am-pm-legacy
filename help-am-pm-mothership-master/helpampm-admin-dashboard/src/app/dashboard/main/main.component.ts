import { Component, OnInit, ViewChild } from '@angular/core';
import {
  ApexAxisChartSeries,
  ApexChart,
  ApexFill, ApexMarkers, ApexPlotOptions, ApexTooltip, ApexXAxis, ApexYAxis, ChartComponent
} from 'ng-apexcharts';
import { firstValueFrom } from 'rxjs';
import { ProfileService } from 'src/app/profile/profile.service';
import { DashboardService } from '../dashboard.service';
import { DashboardConstant } from '../dashbooard-constant';
import { DashboardTopConstant } from '../dashbooard-top-constant';
import { ConstantService } from '../../core/service/constant.service';
export type ChartOptions = {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  xaxis: ApexXAxis;
  yaxis: ApexYAxis | ApexYAxis[];
  labels: string[];
  stroke: any; // ApexStroke;
  markers: ApexMarkers;
  plotOptions: ApexPlotOptions;
  fill: ApexFill;
  tooltip: ApexTooltip;
};

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})

export class MainComponent implements OnInit {
  @ViewChild('chart') chart: ChartComponent;
  public salesChartOptions: any;
  private currentUserDetails: any;
  public customerCount: any;
  public providerCount: any;
  public quotesCount: any;
  public quotesLatest: any;
  public earnings: any;
  public todaysEarnings: any;
  public thisWeeksEarnings: any;
  public thisMonthEarnings: any;

  public todaysCustomers: any;
  public thisWeeksCustomers: any;
  public thisMonthCustomers: any;


  public todaysQuotes: any;
  public thisWeeksQuotes: any;
  public thisMonthQuotes: any;
  public reviews: any;

  bannerChartLabelCustomers = DashboardTopConstant.bannerChartLabelCustomers;

  constructor(private dashboardservice: DashboardService,
    private profileService: ProfileService, private constantService: ConstantService) {
    const userName = localStorage.getItem("userDetails");
    this.currentUserDetails = JSON.parse(userName);
  }

  // Banner chart Customers start
  public bannerChartOptionsCustomers = DashboardTopConstant.bannerChartOptionsCustomers;
  bannerChartDataCustomers = DashboardTopConstant.bannerChartDataCustomers;
  // Banner chart Customers end

  // Banner chart Providers start
  public bannerChartOptionsProviders = DashboardTopConstant.bannerChartOptionsProviders;
  bannerChartDataProviders = DashboardTopConstant.bannerChartDataProviders;
  bannerChartLabelsProviders = DashboardTopConstant.bannerChartLabelsProviders;
  // Banner chart Providers end


  // Banner chart Orders start
  public bannerChartOrders = DashboardTopConstant.bannerChartOrders;
  bannerChartDataOrders = DashboardTopConstant.bannerChartDataOrders;
  bannerChartLabelsOrders = DashboardTopConstant.bannerChartLabelsOrders;
  // Banner chart Orders end


  // Banner chart Revenue start
  public bannerChartRevenue = DashboardTopConstant.bannerChartRevenue;
  bannerChartDataRevenue = DashboardTopConstant.bannerChartDataRevenue;
  bannerChartLabelsRevenue = DashboardTopConstant.bannerChartLabelsRevenue;

  // Banner chart Revenue end

  setStyle(status) {
    return this.constantService.getOrderStatusColorCode(status);
  }

  async ngOnInit(): Promise<any> {
    const data = await firstValueFrom(this.profileService.getUser());
    this.currentUserDetails = data;
    this.loadDashboarddata();
  }

  async loadDashboarddata() {


    this.getlatestQuotes();
    //Earnings
    this.getEarnings();
    this.getTodaysEarnings();
    this.getThisWeeksEarnings();
    this.getThisMonthsEarnings();

    //Customers
    this.getTodaysCustomers();
    this.getThisWeeksCustomers();
    this.getThisMonthsCustomers();

    //Quotes
    this.getTodaysQuotes();
    this.getThisWeeksQuotes();
    this.getThisMonthsQuotes()

    //Reviews
    this.getLatestReviews();

    // charts
    this.salesChart();
    this.customersChart();
    this.providersChart();
    this.ordersChart();
    this.revenueChart();

    // Counts
    this.loadCustomersCount();
    this.loadProvidersCount();
    this.loadQuotesCount();
  }

  private salesChart() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    
    }
    else {

      this.salesChartOptions = DashboardConstant.salesChartOptions;
      this.dashboardservice.getSalesChartData().subscribe(res => {
        this.salesChartOptions.series = [
        res.data['HVAC']==undefined ?[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]:res.data['HVAC'],
        res.data['ELECTRICAL']==undefined ?[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]:res.data['ELECTRICAL'],
        res.data['LOCKSMITH']==undefined ?[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]:res.data['LOCKSMITH'],
        res.data['PLUMBING']==undefined ?[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]:res.data['PLUMBING']
        ];
      });
    }
  }

  private customersChart() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {

      this.dashboardservice.getCustomersChartData().subscribe(res => {
        this.bannerChartDataCustomers[0].data = res.data;
      });
    }
  }

  private providersChart() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {
      this.dashboardservice.getProvidersChartData().subscribe(res => {
        this.bannerChartDataProviders[0].data = res.data;
      });
    }
  }

  private ordersChart() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {
      this.dashboardservice.getOrdersChartData().subscribe(res => {
        this.bannerChartDataOrders[0].data = res.data;
      });
    }
  }

  private revenueChart() {

    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {
      this.dashboardservice.getRevenueChartData().subscribe(res => {
        this.bannerChartDataRevenue[0].data = res.data;
      });
    }
  }


  loadProvidersCount() {

    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {
      this.dashboardservice.getAllProvidersCount().subscribe((res: any) => {
        this.providerCount = res.data;
      });

    }
  }

  loadCustomersCount() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }
    else {

      this.dashboardservice.getAllCustomerCount().subscribe((res: any) => {
        this.customerCount = res.data;
      });
    }
  }

  loadQuotesCount() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    } else {

      this.dashboardservice.getAllQuotes().subscribe((res: any) => {
        this.quotesCount = res.data;
      });
    }
  }

  getlatestQuotes() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
      this.dashboardservice.getLatestProviderQuotes().subscribe((res: any) => {
        this.quotesLatest = res;
      });
    } else {
      this.dashboardservice.getLatestQuotes().subscribe((res: any) => {
        this.quotesLatest = res;
      });
    }
  }

  // Earnings
  getEarnings() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    
    } else {

      this.dashboardservice.getTotalEarnings().subscribe((res: any) => {
        this.earnings = res.data;
      });
    }

  }

  getTodaysEarnings() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }else{

      const today = new Date();
      const d = today.getDate(), y = today.getFullYear(), m = today.getMonth() + 1;
  
      this.dashboardservice.getEarningsByDuration(`${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.todaysEarnings = res.data;
        });
    }
  }

  getThisWeeksEarnings() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    }else{

      const now = new Date();
      const d = now.getDate(), y = now.getFullYear(), m = now.getMonth() + 1;
  
      var weekStart = new Date();
      var first = weekStart.getDate() - weekStart.getDay();
      var weekStartDate = new Date(weekStart.setDate(first));
  
      const wd = weekStartDate.getDate(), wy = weekStartDate.getFullYear(), wm = weekStartDate.getMonth() + 1;
  
      this.dashboardservice.getEarningsByDuration(`${wm.toString().padStart(2, '0')}-${wd.toString().padStart(2, '0')}-${wy}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisWeeksEarnings = res.data;
        });
    }
  }

  getThisMonthsEarnings() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }else{

      var today = new Date(), y = today.getFullYear(), m = today.getMonth();
      var monthStartDate = new Date(y, m, 1);
      const d = today.getDate();
      const md = monthStartDate.getDate(), my = monthStartDate.getFullYear(), mm = monthStartDate.getMonth() + 1;
  
      this.dashboardservice.getEarningsByDuration(`${mm.toString().padStart(2, '0')}-${md.toString().padStart(2, '0')}-${my}`,
        `${(m + 1).toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisMonthEarnings = res.data;
        });
    }
  }


  // Customers
  getTodaysCustomers() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }else{

      const today = new Date();
      const d = today.getDate(), y = today.getFullYear(), m = today.getMonth() + 1;
  
      this.dashboardservice.getCustomersByDuration(`${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.todaysCustomers = res.data;
        });
    }
  }

  getThisWeeksCustomers() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }else{

      const now = new Date();
      const d = now.getDate(), y = now.getFullYear(), m = now.getMonth() + 1;
  
      var weekStart = new Date();
      var first = weekStart.getDate() - weekStart.getDay();
      var weekStartDate = new Date(weekStart.setDate(first));
  
      const wd = weekStartDate.getDate(), wy = weekStartDate.getFullYear(), wm = weekStartDate.getMonth() + 1;
  
      this.dashboardservice.getCustomersByDuration(`${wm.toString().padStart(2, '0')}-${wd.toString().padStart(2, '0')}-${wy}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisWeeksCustomers = res.data;
        });
    }
  }

  getThisMonthsCustomers() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    }
    else {

      var today = new Date(), y = today.getFullYear(), m = today.getMonth();
      var monthStartDate = new Date(y, m, 1);
      const d = today.getDate();
      const md = monthStartDate.getDate(), my = monthStartDate.getFullYear(), mm = monthStartDate.getMonth() + 1;
  
      this.dashboardservice.getCustomersByDuration(`${mm.toString().padStart(2, '0')}-${md.toString().padStart(2, '0')}-${my}`,
        `${(m + 1).toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisMonthCustomers = res.data;
        });
    }
  }

  // Orders
  getTodaysQuotes() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
    } else {

      const today = new Date();
      const d = today.getDate(), y = today.getFullYear(), m = today.getMonth() + 1;

      this.dashboardservice.getQuotesByDuration(`${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.todaysQuotes = res.data;
        });
    }
  }

  getThisWeeksQuotes() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    } else {

      const now = new Date();
      const d = now.getDate(), y = now.getFullYear(), m = now.getMonth() + 1;

      var weekStart = new Date();
      var first = weekStart.getDate() - weekStart.getDay();
      var weekStartDate = new Date(weekStart.setDate(first));

      const wd = weekStartDate.getDate(), wy = weekStartDate.getFullYear(), wm = weekStartDate.getMonth() + 1;


      this.dashboardservice.getQuotesByDuration(`${wm.toString().padStart(2, '0')}-${wd.toString().padStart(2, '0')}-${wy}`,
        `${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisWeeksQuotes = res.data;
        });
    }
  }

  getThisMonthsQuotes() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {

    }
    else {

      var today = new Date(), y = today.getFullYear(), m = today.getMonth();
      var monthStartDate = new Date(y, m, 1);
      const d = today.getDate();
      const md = monthStartDate.getDate(), my = monthStartDate.getFullYear(), mm = monthStartDate.getMonth() + 1;

      this.dashboardservice.getQuotesByDuration(`${mm.toString().padStart(2, '0')}-${md.toString().padStart(2, '0')}-${my}`,
        `${(m + 1).toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}-${y}`).subscribe((res: any) => {
          this.thisMonthQuotes = res.data;
        });
    }
  }



  getLatestReviews() {
    if (this.currentUserDetails != null && this.currentUserDetails.authority == 'ROLE_PROVIDER_ADMIN' || this.currentUserDetails.authority == 'ROLE_PROVIDER_EMPLOYEE' ) {
      this.dashboardservice.getLatestProviderReviews(this.currentUserDetails.providerUniqueId).subscribe(res => {
        this.reviews = res;
      })
    }
    else {
      this.dashboardservice.getLatestReviews().subscribe((res: any) => {
        this.reviews = res;
      });
    }
  }



  showIcon(index, rating) {
    if (rating >= index + 1) {
      return 'star';
    } else {
      return 'star_border';
    }
  }

}
