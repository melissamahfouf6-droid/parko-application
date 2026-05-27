import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('parking_reservations')
export class ParkingReservation {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  userId!: string;

  @Column()
  lotId!: string;

  @Column()
  lotName!: string;

  @Column({ type: 'float', nullable: true })
  lat!: number | null;

  @Column({ type: 'float', nullable: true })
  lng!: number | null;

  @Column({ type: 'datetime' })
  startAt!: Date;

  @Column({ type: 'datetime' })
  endAt!: Date;

  @Column({ type: 'float' })
  priceKwd!: number;

  @Column({ type: 'varchar', default: 'confirmed' })
  status!: string;

  @Column({ type: 'varchar', nullable: true })
  zoneLabel!: string | null;

  @Column({ type: 'boolean', default: false })
  walletPaid!: boolean;

  @CreateDateColumn()
  createdAt!: Date;
}
