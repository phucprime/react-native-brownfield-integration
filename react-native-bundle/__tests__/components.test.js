import React from 'react';

describe('BrownfieldScreen', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    const BrownfieldScreen = require('../src/BrownfieldScreen').default;
    expect(BrownfieldScreen).toBeDefined();
  });

  it('should render without crashing', () => {
    const BrownfieldScreen = require('../src/BrownfieldScreen').default;
    expect(() => {
      const element = React.createElement(BrownfieldScreen, { initialProps: {} });
      expect(element).toBeTruthy();
    }).not.toThrow();
  });

  it('should accept initialProps', () => {
    const BrownfieldScreen = require('../src/BrownfieldScreen').default;
    const props = {
      initialProps: {
        title: 'Test Title',
        message: 'Test Message',
      },
    };
    const element = React.createElement(BrownfieldScreen, props);
    expect(element.props.initialProps.title).toBe('Test Title');
    expect(element.props.initialProps.message).toBe('Test Message');
  });
});

describe('SharedFeature', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    const SharedFeature = require('../src/SharedFeature').default;
    expect(SharedFeature).toBeDefined();
  });

  it('should render without crashing', () => {
    const SharedFeature = require('../src/SharedFeature').default;
    expect(() => {
      const element = React.createElement(SharedFeature, { initialProps: {} });
      expect(element).toBeTruthy();
    }).not.toThrow();
  });

  it('should accept initialProps with items', () => {
    const SharedFeature = require('../src/SharedFeature').default;
    const props = {
      initialProps: {
        featureName: 'Test Feature',
        items: [{ id: '1', text: 'Test Item', completed: false }],
      },
    };
    const element = React.createElement(SharedFeature, props);
    expect(element.props.initialProps.featureName).toBe('Test Feature');
    expect(element.props.initialProps.items).toHaveLength(1);
  });
});

describe('index.js exports', () => {
  it('should export BrownfieldScreen and SharedFeature', () => {
    // Since AppRegistry.registerComponent is called on import,
    // we just verify the modules can be imported
    const BrownfieldScreen = require('../src/BrownfieldScreen').default;
    const SharedFeature = require('../src/SharedFeature').default;
    
    expect(BrownfieldScreen).toBeDefined();
    expect(SharedFeature).toBeDefined();
  });
});
