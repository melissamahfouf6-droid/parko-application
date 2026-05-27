import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('parking_sessions')
export class ParkingSessionRecord {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar' })
  userId!: string;

  @Column({ type: 'varchar' })
  lotId!: string;

  @Column({ type: 'varchar' })
  lotName!: string;

  @Column({ type: 'float' })
  paidKwd!: number;

  @Column({ type: 'int', default: 120 })
  durationMinutes!: number;

  @Column({ type: 'varchar', default: 'completed' })
  status!: string;

  @CreateDateColumn()
  startedAt!: Date;
}
