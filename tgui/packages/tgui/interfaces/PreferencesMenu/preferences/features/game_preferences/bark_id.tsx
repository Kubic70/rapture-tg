import { FeatureChoiced, FeatureDropdownInput, FeatureKnobInput, FeatureNumeric, FeatureToggle, CheckboxInput } from '../base';

export const bark_id: FeatureChoiced = {
  name: 'Voice',
  category: 'bark_data',
  component: FeatureDropdownInput,
};

export const bark_speed: FeatureNumeric = {
  name: 'Speed',
  category: 'bark_data',
  component: FeatureKnobInput,
};

export const bark_pitch: FeatureNumeric = {
  name: 'Pitch',
  category: 'bark_data',
  component: FeatureKnobInput,
};

export const bark_variance: FeatureNumeric = {
  name: 'Variance',
  category: 'bark_data',
  component: FeatureKnobInput,
};

export const sound_bark: FeatureToggle = {
  name: 'Enable Barking',
  category: 'SOUND',
  description: 'When enabled, be able to hear speech sounds in game.',
  component: CheckboxInput,
};
