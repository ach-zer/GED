import { TestBed } from '@angular/core/testing';

import { DocAcqService } from './doc-acq.service';

describe('DocAcqService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocAcqService = TestBed.get(DocAcqService);
    expect(service).toBeTruthy();
  });
});
