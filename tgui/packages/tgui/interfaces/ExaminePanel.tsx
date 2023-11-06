import { useBackend } from '../backend';
import { Stack, Section, ByondUi } from '../components';
import { Window } from '../layouts';
import { resolveAsset } from '../assets';

export type ExamineData = {
  character_name: string;
  obscured: boolean;
  assigned_map: string;
  flavor_text: string;
  ooc_notes: string;
  headshot: string;
};

export const ExaminePanel = (props, context) => {
  const { act, data } = useBackend<ExamineData>(context);
  const {
    character_name,
    obscured,
    assigned_map,
    flavor_text,
    ooc_notes,
    headshot,
  } = data;
  return (
    <Window title="Examine Panel" width={900} height={638} theme="ntos">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="263px">
            {!headshot ? (
              <Section fill title="Character Preview">
                {!obscured && (
                  <ByondUi
                    height="100%"
                    width="100%"
                    params={{
                      id: assigned_map,
                      type: 'map',
                    }}
                  />
                )}
              </Section>
            ) : (
              <>
                <Section height="294px" title="Character Preview">
                  {!obscured && (
                    <ByondUi
                      height="250px"
                      width="100%"
                      params={{
                        id: assigned_map,
                        type: 'map',
                      }}
                    />
                  )}
                </Section>
                <Section height="294px" title="Headshot">
                  <div
                    style={{
                      'height': '250px',
                      'width': '100%',
                      'display': 'flex',
                      'justify-content': 'center',
                      'align-items': 'center',
                    }}>
                    <img
                      src={resolveAsset(headshot)}
                      style={{
                        'max-height': '250px',
                        'max-width': '250px',
                        'object-fit': 'contain',
                      }}
                    />
                  </div>
                </Section>
              </>
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item grow>
                <Section
                  scrollable
                  fill
                  title={character_name + "'s Flavor Text:"}
                  preserveWhitespace>
                  {flavor_text}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item grow basis={0}>
                    <Section
                      scrollable
                      fill
                      title="OOC Notes"
                      preserveWhitespace>
                      {ooc_notes}
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
