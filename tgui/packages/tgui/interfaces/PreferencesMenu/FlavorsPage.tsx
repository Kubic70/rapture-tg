import features from './preferences/features';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';
import { sendAct, useBackend, useLocalState } from '../../backend';
import { Tabs, Box, TextArea, Stack, Section, LabeledList, Button, LabeledControls, Input, BlockQuote } from '../../components';
import { PreferencesMenuData, createSetPreference } from './data';
import { sortBy } from 'common/collections';
import { FeatureValueInput } from './preferences/features/base';

const sortPreferences = sortBy<[string, unknown]>(([featureId, _]) => {
  const feature = features[featureId];
  return feature?.name;
});

const PreferenceList = (props: {
  act: typeof sendAct;
  preferences: Record<string, unknown>;
}) => {
  return (
    <LabeledList>
      {Object.entries(props.preferences).map(([featureId, value]) => {
        const feature = features[featureId];

        if (feature === undefined) {
          return (
            <Stack.Item key={featureId}>
              <b>Feature {featureId} is not recognized.</b>
            </Stack.Item>
          );
        }

        if (featureId === 'bark_id') {
          return (
            <LabeledList.Item
              key={featureId}
              label={feature.name}
              verticalAlign="middle">
              <Stack fill>
                <Stack.Item grow>
                  <FeatureValueInput
                    act={props.act}
                    feature={feature}
                    featureId={featureId}
                    value={value}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    content="Preview"
                    height="22px"
                    onClick={() =>
                      props.act('bark_preview', {
                        barkid: props.preferences['bark_id'],
                        barkspeed: props.preferences['bark_speed'],
                        barkpitch: props.preferences['bark_pitch'],
                        barkvariance: props.preferences['bark_variance'],
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
          );
        }
      })}
    </LabeledList>
  );
};

const PreferenceControl = (props: {
  act: typeof sendAct;
  preferences: Record<string, unknown>;
}) => {
  return (
    <LabeledControls ml={10} mr={10} align="center">
      {Object.entries(props.preferences).map(([featureId, value]) => {
        const feature = features[featureId];

        if (feature === undefined) {
          return (
            <Stack.Item key={featureId}>
              <b>Feature {featureId} is not recognized.</b>
            </Stack.Item>
          );
        }

        if (
          featureId === 'bark_speed' ||
          featureId === 'bark_pitch' ||
          featureId === 'bark_variance'
        ) {
          return (
            <LabeledControls.Item key={featureId} label={feature.name}>
              <FeatureValueInput
                act={props.act}
                feature={feature}
                featureId={featureId}
                value={value}
              />
            </LabeledControls.Item>
          );
        }
      })}
    </LabeledControls>
  );
};

export const FlavorsPage = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);

  const changeValue = (key, newValue) => {
    createSetPreference(act, key)(newValue);
  };

  const [tab, setTab] = useLocalState(context, 'tab', 'carbon');
  const [headshot, setHeadshot] = useLocalState(
    context,
    `headshot_${data.active_slot}`,
    data.character_preferences.headshot_data['headshot']
  );
  const [headshot_silicon, setHeadshot_silicon] = useLocalState(
    context,
    `headshot_silicon_${data.active_slot}`,
    data.character_preferences.headshot_data['headshot_silicon']
  );

  const [flavor_text, setflavor_text] = useLocalState(
    context,
    `flavor_text_${data.active_slot}`,
    data.character_preferences.flavor_data['flavor_text']
  );

  const [silicon_flavor_text, setsilicon_flavor_text] = useLocalState(
    context,
    `silicon_flavor_text_${data.active_slot}`,
    data.character_preferences.flavor_data['silicon_flavor_text']
  );

  const [ooc_notes, setooc_notes] = useLocalState(
    context,
    `ooc_notes_${data.active_slot}`,
    data.character_preferences.flavor_data['ooc_notes']
  );

  const [security_record, setsecurity_record] = useLocalState(
    context,
    `security_record_${data.active_slot}`,
    data.character_preferences.flavor_data['security_record']
  );
  const [medical_record, setmedical_record] = useLocalState(
    context,
    `medical_record_${data.active_slot}`,
    data.character_preferences.flavor_data['medical_record']
  );
  const [general_record, setgeneral_record] = useLocalState(
    context,
    `general_record_${data.active_slot}`,
    data.character_preferences.flavor_data['general_record']
  );

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        const barkPreferences = {
          ...data.character_preferences.bark_data,
        };

        return (
          <Stack fill vertical>
            <Stack.Item>
              <Stack my={1}>
                <Stack.Item>
                  <Section
                    title="Headshot Preview"
                    height="479px"
                    width="418px">
                    <Tabs fluid textAlign="center">
                      <Tabs.Tab
                        selected={tab === 'carbon'}
                        onClick={() => setTab('carbon')}>
                        Carbon
                      </Tabs.Tab>
                      <Tabs.Tab
                        selected={tab === 'silicon'}
                        onClick={() => setTab('silicon')}>
                        Silicon
                      </Tabs.Tab>
                    </Tabs>
                    {tab === 'carbon' && (
                      <div
                        style={{
                          'height': '400px',
                          'width': '100%',
                          'display': 'flex',
                          'justify-content': 'center',
                          'align-items': 'center',
                        }}>
                        <img
                          src={headshot}
                          style={{
                            'max-height': '400px',
                            'max-width': '400px',
                            'object-fit': 'contain',
                          }}
                        />
                      </div>
                    )}
                    {tab === 'silicon' && (
                      <div
                        style={{
                          'height': '400px',
                          'width': '100%',
                          'display': 'flex',
                          'justify-content': 'center',
                          'align-items': 'center',
                        }}>
                        <img
                          src={headshot_silicon}
                          style={{
                            'max-height': '400px',
                            'max-width': '400px',
                            'object-fit': 'contain',
                          }}
                        />
                      </div>
                    )}
                  </Section>
                </Stack.Item>
                <Stack.Item grow>
                  <Stack vertical>
                    <Stack.Item>
                      {/* Сделать авторазмер до заполнения оставшегося места */}
                      <Section title="Info" scrollable>
                        <Box height="159px">
                          <BlockQuote>
                            <Box mt={1} bold>
                              Headshot
                            </Box>
                            <Box italic>- Не используйте фотографии</Box>
                            <Box italic>
                              - Используйте только SFW изображения
                            </Box>
                            <Box italic>
                              - Разрешеные хосты изображений
                              &quot;media.discordapp.net&quot; и
                              &quot;cdn.discordapp.com&quot;
                            </Box>
                          </BlockQuote>
                          <BlockQuote>
                            <Box mt={1} bold>
                              Flavor
                            </Box>
                            <Box italic>
                              - Это описание внешности вашего персонажа от 3го
                              лица
                            </Box>
                            <Box italic>
                              - Не расписывайте здесь всю историю персонажа
                            </Box>
                            <Box italic>- Лимит 4096 символов</Box>
                          </BlockQuote>
                          <BlockQuote>
                            <Box mt={1} bold>
                              OOC Notes
                            </Box>
                            <Box italic>
                              - Поле для информации не относящийся к персонажу
                            </Box>
                          </BlockQuote>
                          <BlockQuote>
                            <Box mt={1} bold>
                              Security Records
                            </Box>
                            <Box italic>
                              - Эти записи появятся в терминале Службы
                              Безопасности
                            </Box>
                          </BlockQuote>
                          <BlockQuote>
                            <Box mt={1} bold>
                              Medical Records
                            </Box>
                            <Box italic>
                              - Эти записи появятся в терминале Медецинского
                              отдела
                            </Box>
                          </BlockQuote>
                          <BlockQuote>
                            <Box mt={1} bold>
                              General Records
                            </Box>
                            <Box italic>
                              - Это общие записи о персонале
                            </Box>
                          </BlockQuote>
                        </Box>
                      </Section>
                    </Stack.Item>
                    <Stack.Item>
                      <Section title="Headshot">
                        <LabeledList>
                          <LabeledList.Item label="Carbon URL">
                            <Input
                              width="100%"
                              value={headshot}
                              onChange={(e, value) => {
                                setHeadshot(value);
                                changeValue('headshot', value);
                              }}
                            />
                          </LabeledList.Item>
                          <LabeledList.Item label="Silicon URL">
                            <Input
                              width="100%"
                              value={headshot_silicon}
                              onChange={(e, value) => {
                                setHeadshot_silicon(value);
                                changeValue('headshot_silicon', value);
                              }}
                            />
                          </LabeledList.Item>
                        </LabeledList>
                      </Section>
                    </Stack.Item>
                    <Stack.Item>
                      <Section title="Voice">
                        <Stack my={1}>
                          <Stack.Item>
                            <PreferenceList
                              act={act}
                              preferences={barkPreferences}
                            />
                            <Box my={2} />
                            <PreferenceControl
                              act={act}
                              preferences={barkPreferences}
                            />
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
              <Section />
              <Stack my={1}>
                <Stack.Item basis="50%">
                  <Section title="Flavor">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={flavor_text}
                      height={'150px'}
                      onChange={(e, value) => {
                        setflavor_text(value);
                        changeValue('flavor_text', value);
                      }}
                    />
                  </Section>
                  <Section title="Silicon Flavor">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={silicon_flavor_text}
                      height={'150px'}
                      onChange={(e, value) => {
                        setsilicon_flavor_text(value);
                        changeValue('silicon_flavor_text', value);
                      }}
                    />
                  </Section>
                  <Section title="OOC Notes">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={ooc_notes}
                      height={'150px'}
                      onChange={(e, value) => {
                        setooc_notes(value);
                        changeValue('ooc_notes', value);
                      }}
                    />
                  </Section>
                </Stack.Item>
                <Stack.Item basis="50%">
                  <Section title="Security Records">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={security_record}
                      height={'150px'}
                      onChange={(e, value) => {
                        setsecurity_record(value);
                        changeValue('security_record', value);
                      }}
                    />
                  </Section>
                  <Section title="Medical Records">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={medical_record}
                      height={'150px'}
                      onChange={(e, value) => {
                        setmedical_record(value);
                        changeValue('medical_record', value);
                      }}
                    />
                  </Section>
                  <Section title="General Records">
                    <TextArea
                      style={{
                        background: 'rgba(0,0,0,0.5)',
                        padding: '4px',
                      }}
                      scrollbar
                      noborder
                      value={general_record}
                      height={'150px'}
                      onChange={(e, value) => {
                        setgeneral_record(value);
                        changeValue('general_record', value);
                      }}
                    />
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};
