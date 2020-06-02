import { TestBed } from '@angular/core/testing';

import { DocIdenService } from './doc-iden.service';

describe('DocIdenService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DocIdenService = TestBed.get(DocIdenService);
    expect(service).toBeTruthy();
  });
});
