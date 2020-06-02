import { TestBed } from '@angular/core/testing';

import { DocsSearchService } from './docs-search.service';

describe('DocsSearchService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocsSearchService = TestBed.get(DocsSearchService);
    expect(service).toBeTruthy();
  });
});
