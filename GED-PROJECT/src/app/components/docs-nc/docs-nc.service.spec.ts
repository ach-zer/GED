import { TestBed } from '@angular/core/testing';

import { DocsNcService } from './docs-nc.service';

describe('DocsNcService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocsNcService = TestBed.get(DocsNcService);
    expect(service).toBeTruthy();
  });
});
