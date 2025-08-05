import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

import { EncryptStorage } from 'encrypt-storage';

@Injectable({
  providedIn: 'root'
})

export class StorageService {

  constructor(private router: Router) { }

  private token;
  private users;
  private leadSource;
  private loggedInUser;
  private leadType;
  private leadStatus;
  private roles;
  private projects;
  private leadInventorySize;
  private deactivationReasons;

  public $metaData = new EncryptStorage('secret-key-value', {
    storageType: 'sessionStorage',
  });

  private metadata = {
    'loggedInUser': {},
    'leadStatus': [],
    'leadSources': [],
    'leadType': [],
    'roles': [],
    'users': [],
    'projects': [],
    'leadInventorySize': [],
    'deactivationReasons': []
  };


  getToken() {
    return this.token;
  }
  getUsers() {
    return this.users;
  }
  getLeadSource() {
    return this.leadSource;
  }
  getLeadStatus() {
    return this.leadStatus;
  }
  getLeadType() {
    return this.leadType;
  }
  getRoles() {
    return this.roles;
  }
  getProjects() {
    return this.projects;
  }
  getLeadInventorySize() {
    return this.leadInventorySize;
  }

  getloggedInUser() {
    return this.loggedInUser;
  }

  getDeactivationReasons() {
    return this.deactivationReasons;
  }

  /*setter */
  setloggedInUser(loggedInUser) {
    this.loggedInUser = loggedInUser;
  }

  setToken(token) {
    this.token = token;
  }

  setUsers(users) {
    this.users = users;
  }

  setProjects(projects) {
    this.projects = projects;
  }

  setLeadSource(leadSource) {
    this.leadSource = leadSource;
  }

  setLeadType(leadSource) {
    this.leadType = leadSource;
  }

  setLeadStatus(leadStatus) {
    this.leadStatus = leadStatus;
  }
  setRoles(roles) {
    this.roles = roles;
  }

  setLeadInventorySize(leadInventorySize) {
    this.leadInventorySize = leadInventorySize;
  }

  setDeactivationReasons(deactivationReasons) {
    this.deactivationReasons = deactivationReasons;
  }

  getStorage() {
    try {
      return this.$metaData.getItem('metadata');
    }
    catch (e) {
      this.$metaData.clear();
      this.router.navigate(['/authentication/signin', {}]);
    }
  }

  clearStorage() {
    return this.$metaData.clear();
  }

  setMetaData() {
    this.metadata.leadSources = this.leadSource;
    this.metadata.leadStatus = this.leadStatus;
    this.metadata.leadType = this.leadType;
    this.metadata.roles = this.roles;
    this.metadata.users = this.users;
    this.metadata.projects = this.projects;
    this.metadata.loggedInUser = this.loggedInUser;
    this.metadata.leadInventorySize = this.leadInventorySize;
    this.metadata.deactivationReasons = this.deactivationReasons;
    this.$metaData.setItem('metadata', this.metadata)
  }

  /**
   * @param data data to be add
   * @param storageType USER,LEAD_SOURCE,LEAD_TYPE,ROLE,INVENTORY_SIZE
   */
  updateMetadata(data, storageType) {
    let metadataCurrent = this.$metaData.getItem('metadata');
    switch (storageType) {
      case 'USER':
        metadataCurrent.users.push(data);
        break;
  
      case 'ROLE':
        metadataCurrent.users.push(data);
        break;
      default:
        break;
    }
    this.$metaData.setItem('metadata', metadataCurrent)
  }

}
